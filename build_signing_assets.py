#!/usr/bin/env python3
import argparse
import subprocess
import pathlib
import base64

def run(cmd):
    print("[cmd]", " ".join(cmd))
    subprocess.check_call(cmd)

def b64(path):
    return base64.b64encode(path.read_bytes()).decode()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--cert", required=True)
    parser.add_argument("--key", required=True)
    parser.add_argument("--mobileprovision", required=True)
    parser.add_argument("--p12-password", required=True)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    out = pathlib.Path(args.out)
    out.mkdir(exist_ok=True)

    cert = pathlib.Path(args.cert)
    key = pathlib.Path(args.key)
    mp = pathlib.Path(args.mobileprovision)

    p12 = out / "dev_cert.p12"
    mp_out = out / "dev.mobileprovision"

    # Build p12
    run([
        "openssl", "pkcs12",
        "-export",
        "-inkey", str(key),
        "-in", str(cert),
        "-out", str(p12),
        "-password", f"pass:{args.p12_password}"
    ])

    # Copy mobileprovision
    mp_out.write_bytes(mp.read_bytes())

    # Print secrets for GitHub
    print("\n=== COPY THESE INTO GITHUB SECRETS ===")
    print("APPLE_DEV_CERT_PEM_B64=", b64(cert))
    print("APPLE_DEV_KEY_PEM_B64=", b64(key))
    print("APPLE_DEV_MOBILEPROVISION_B64=", b64(mp))
    print("P12_PASSWORD=", args.p12_password)
    print("======================================\n")

    print("Generated:")
    print("  ", p12)
    print("  ", mp_out)

if __name__ == "__main__":
    main()
