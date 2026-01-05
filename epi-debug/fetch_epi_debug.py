#!/usr/bin/env python3
"""
Fetch EPI Center Details Debug Script

This script replicates the Flutter app's API call to fetch EPI center details
and saves the cleaned/parsed JSON response to a file for debugging.

Usage:
    python fetch_epi_debug.py [org_uid] [year]
    
Examples:
    python fetch_epi_debug.py null 2025
    python fetch_epi_debug.py some-uid-here 2024
"""

import json
import requests
import sys
from typing import Any, Dict, List, Union
from pathlib import Path


def decode_epi_center_details_nested_json(input_data: Any) -> Any:
    """
    Recursively decode any stringified JSON until fully converted.
    
    This function handles nested JSON strings within EPI center details JSON response.
    It's a Python equivalent of the Dart function in epi_utils.dart.
    
    Args:
        input_data: The input data to decode (can be dict, list, str, or other)
        
    Returns:
        Fully decoded data structure
    """
    if isinstance(input_data, dict):
        # Ensure keys are strings and recursively decode values
        return {
            str(key): decode_epi_center_details_nested_json(value)
            for key, value in input_data.items()
        }
    elif isinstance(input_data, list):
        # Recursively decode list items
        return [decode_epi_center_details_nested_json(item) for item in input_data]
    elif isinstance(input_data, str):
        # Try to decode string as JSON
        decoded = input_data
        did_decode = True
        
        while did_decode:
            did_decode = False
            try:
                temp = json.loads(decoded)
                if isinstance(temp, (dict, list)):
                    decoded = decode_epi_center_details_nested_json(temp)
                    did_decode = True
                else:
                    decoded = temp
            except (json.JSONDecodeError, TypeError):
                # Not a JSON string, stop trying
                break
        
        return decoded
    else:
        # Return as-is for other types (int, float, bool, None, etc.)
        return input_data


def fetch_epi_center_details(org_uid: str = "null", year: str = "2025") -> Dict[str, Any]:
    """
    Fetch EPI center details from the API.
    
    Args:
        org_uid: The organization UID (use "null" for country level)
        year: The year for the data
        
    Returns:
        Parsed and cleaned JSON response
        
    Raises:
        requests.RequestException: If the API call fails
    """
    # Construct the API URL (matching the Flutter app)
    base_url = "https://staging.gisdashboard.online"
    # url = f"{base_url}/chart/{org_uid}?year={year}&request-from=app"
    url = 'https://staging.gisdashboard.online/chart/lnuF3c6qhdh?year=2026&request-from=app'
    
    print(f"🔄 Fetching EPI details from: {url}")
    
    # Make the API request (disable SSL verification to match staging SSL bypass)
    response = requests.get(url, verify=False, timeout=30)
    
    print(f"✅ Response status: {response.status_code}")
    
    # Check if response is successful
    if response.status_code != 200:
        raise Exception(f"Server returned status code: {response.status_code}")
    
    # Check content type
    content_type = response.headers.get('content-type', '')
    print(f"📄 Content-Type: {content_type}")
    
    # Reject HTML responses
    if 'text/html' in content_type or response.text.strip().startswith('<'):
        raise Exception("EPI_CENTER_NO_DATA - Received HTML instead of JSON")
    
    # Get raw JSON data
    raw_data = response.json()
    print(f"✅ Raw JSON received (type: {type(raw_data).__name__})")
    
    # Decode and parse nested JSON (matching the Flutter app's logic)
    print("🔄 Decoding and parsing nested JSON...")
    parsed_json = decode_epi_center_details_nested_json(raw_data)
    print("✅ JSON parsing complete")
    
    return parsed_json


def save_json_to_file(data: Dict[str, Any], filename: str = "epi_center_details_debug_for_epi.json") -> Path:
    """
    Save the parsed JSON data to a file.
    
    Args:
        data: The JSON data to save
        filename: The output filename
        
    Returns:
        Path to the saved file
    """
    output_path = Path(__file__).parent / filename
    
    print(f"💾 Saving JSON to: {output_path}")
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"✅ Successfully saved JSON to: {output_path}")
    print(f"📊 File size: {output_path.stat().st_size / 1024:.2f} KB")
    
    return output_path


def main():
    """Main entry point for the script."""
    # Suppress SSL warnings (since we're bypassing SSL verification for staging)
    import urllib3
    urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    
    # Parse command line arguments
    org_uid = sys.argv[1] if len(sys.argv) > 1 else "null"
    year = sys.argv[2] if len(sys.argv) > 2 else "2025"
    
    print("=" * 80)
    print("🚀 EPI Center Details Fetch & Debug Script")
    print("=" * 80)
    print(f"   Org UID: {org_uid}")
    print(f"   Year: {year}")
    print("=" * 80)
    print()
    
    try:
        # Fetch the data
        parsed_data = fetch_epi_center_details(org_uid=org_uid, year=year)
        
        # Save to file
        output_file = save_json_to_file(parsed_data)
        
        print()
        print("=" * 80)
        print("✅ SUCCESS! Data fetched and saved.")
        print("=" * 80)
        print(f"📁 Open the file to inspect: {output_file}")
        print()
        
        # Print some quick stats about the data
        print("📊 Quick Stats:")
        if isinstance(parsed_data, dict):
            print(f"   - Top-level keys: {len(parsed_data)}")
            print(f"   - Keys: {', '.join(list(parsed_data.keys())[:10])}")
            
            # Check for area data
            if 'area' in parsed_data and parsed_data['area']:
                area = parsed_data['area']
                print(f"   - Area name: {area.get('name', 'N/A')}")
                print(f"   - Area type: {area.get('type', 'N/A')}")
                
                # Check for additional_data -> demographics
                if 'additional_data' in area and area['additional_data']:
                    demographics = area['additional_data'].get('demographics', {})
                    print(f"   - Demographics years available: {list(demographics.keys())}")
        
        return 0
        
    except Exception as e:
        print()
        print("=" * 80)
        print(f"❌ ERROR: {str(e)}")
        print("=" * 80)
        return 1


if __name__ == "__main__":
    sys.exit(main())
