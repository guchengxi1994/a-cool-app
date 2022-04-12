import os

frontend_version_file_path = "./frontend/codind/pubspec.yaml"
backend_version_file_path = "./backend/common/__init__.py"

assert os.path.exists(frontend_version_file_path) and os.path.exists(
    backend_version_file_path), "file not found"

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-f", "--frontend", help="frontend version")
parser.add_argument("-b", "--backend", help="backend version")

if __name__ == "__main__":
    args = parser.parse_args()
    # print(args.frontend)
    if args.frontend is None and args.backend is None:
        print("nothing to do")

    if args.frontend is not None:
        with open(frontend_version_file_path, "r") as f:
            line_list = [line for line in f]
        # with open("./frontend/codind/pubspec.yaml.bak",
        #             "w",
        #             encoding="utf-8") as fw:
        #     for i in line_list:
        #         # print(i)
        #         fw.write(i)

        with open("./frontend/codind/pubspec.yaml",
                    "w",
                    encoding="utf-8") as f:
            for index in range(0, len(line_list)):
                if line_list[index].startswith("version: "):
                    line_list[index] = "version: " + args.frontend
                f.write(line_list[index])
                
            # f.writelines(line_list)
