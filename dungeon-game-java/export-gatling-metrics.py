import re
import requests
import json
import time
import os
import glob
from collections import defaultdict

def send_to_pushgateway(metric_name, value, labels="", help_text="", pushgateway_url="http://localhost:9091"):
    """Send a metric to Prometheus PushGateway"""
    url = f"{pushgateway_url}/metrics/job/gatling"
    data = f"# HELP {metric_name} {help_text}\n# TYPE {metric_name} gauge\n{metric_name}{labels} {value}\n"
    print(f"➡️ Sending to PushGateway: {data.strip()}")
    try:
        response = requests.post(url, data=data, headers={'Content-Type': 'text/plain'})
        return response.status_code == 200
    except Exception as e:
        print(f"❌ Error sending to PushGateway: {e}")
        return False

def process_gatling_log(log_file_path):
    """Process Gatling simulation.log file and extract metrics"""
    request_times = []
    errors = 0
    total_requests = 0
    status_codes = defaultdict(int)
    
    try:
        with open(log_file_path, 'r') as f:
            for line in f:
                parts = line.strip().split('\t')

                if len(parts) >= 6 and parts[0] == 'REQUEST':
                    total_requests += 1
                    start_time = int(parts[3])
                    end_time = int(parts[4])
                    response_time = end_time - start_time
                    status = parts[5]
                    
                    request_times.append(response_time)
                    if status == 'OK':
                        status_codes['success'] += 1
                    else:
                        errors += 1
                        status_codes['failed'] += 1
    
        if request_times:
            request_times.sort()
            
            # Calculate percentiles
            p50 = request_times[int(len(request_times) * 0.50)] / 1000.0
            p95 = request_times[int(len(request_times) * 0.95)] / 1000.0
            p99 = request_times[int(len(request_times) * 0.99)] / 1000.0
            
            avg_response_time = sum(request_times) / len(request_times) / 1000.0
            error_rate = errors / total_requests if total_requests > 0 else 0
            
            # Send metrics to PushGateway
            current_time = int(time.time())
            
            send_to_pushgateway("gatling_requests_total", total_requests, '{job="gatling"}', "Total requests")
            send_to_pushgateway("gatling_requests_failed_total", errors, '{job="gatling"}', "Failed requests")
            send_to_pushgateway("gatling_response_time_seconds", p50, '{job="gatling",quantile="0.5"}', "P50 response time")
            send_to_pushgateway("gatling_response_time_seconds", p95, '{job="gatling",quantile="0.95"}', "P95 response time")
            send_to_pushgateway("gatling_response_time_seconds", p99, '{job="gatling",quantile="0.99"}', "P99 response time")
            send_to_pushgateway("gatling_error_rate", error_rate, '{job="gatling"}', "Error rate")
            
            print(f"📊 Processed {total_requests} requests, {errors} errors")
            print(f"📈 P50: {p50:.2f}s, P95: {p95:.2f}s, P99: {p99:.2f}s")
            print(f"📊 Error rate: {error_rate:.2%}")
            
            return True
        else:
            print("⚠️ No request data found")
            return False
            
    except Exception as e:
        print(f"❌ Error processing log: {e}")
        return False

def find_latest_gatling_log():
    """
    Finds the most recent Gatling simulation log using the lastRun.txt file.
    """
    last_run_file = "target/gatling/lastRun.txt"

    if not os.path.exists(last_run_file):
        return None

    try:
        with open(last_run_file, 'r') as f:
            simulation_dir_name = f.read().strip()

        if not simulation_dir_name:
            return None

        latest_dir = os.path.join("target/gatling", simulation_dir_name)
        log_file = os.path.join(latest_dir, "simulation.log")
        print(f"🔍 Found log file: {log_file}")
        if os.path.exists(log_file):
            return log_file
        else:
            return None

    except IOError:
        return None

if __name__ == "__main__":
    print("🚀 Exporting Gatling metrics...")
    
    # Check PushGateway
    try:
        requests.get("http://localhost:9091/metrics", timeout=5)
    except:
        print("❌ PushGateway not accessible at http://localhost:9091")
        exit(1)
    
    # Find and process log
    log_file = find_latest_gatling_log()
    if log_file:
        if process_gatling_log(log_file):
            print("✅ Metrics exported successfully!")
            print("🔗 View at: http://localhost:3000")
        else:
            print("❌ Failed to export metrics")
    else:
        print("❌ No Gatling log found. Run a test first.")
        print("   mvn gatling:test -Dgatling.simulationClass=DungeonGameBasicLoadTestWithMetrics")
