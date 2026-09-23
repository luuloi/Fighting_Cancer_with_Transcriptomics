# TÀI LIỆU HỌC TẬP: KHÓA HỌC FCWT 2026
## BÀI 02: HỆ ĐIỀU HÀNH LINUX & QUẢN TRỊ HỆ THỐNG TỆP TIN (FILE SYSTEM NAVIGATION)

---

### BẢNG TRA CỨU THUẬT NGỮ CHUYÊN NGÀNH (GLOSSARY)

| Thuật ngữ tiếng Anh | Ý nghĩa / Định nghĩa |
| :--- | :--- |
| **CLI (Command Line Interface)** | Giao diện dòng lệnh (tương tác với máy tính bằng văn bản) |
| **GUI (Graphical User Interface)** | Giao diện đồ họa người dùng (tương tác qua cửa sổ, chuột, nút bấm) |
| **HPC (High-Performance Computing)** | Hệ thống máy tính tính toán hiệu năng cao (Server từ xa) |
| **Reproducibility** | Tính tái lập / khả năng lặp lại chính xác của một nghiên cứu/phân tích |
| **Linux Distribution (Distro)** | Bản phân phối Linux (như Ubuntu, Debian, Fedora, Arch Linux) |
| **Kernel** | Nhân hệ điều hành – tầng cốt lõi quản lý phần cứng và tài nguyên máy tính |
| **Package Manager** | Trình quản lý gói phần mềm (như `apt`, `dnf`, `pacman`, `snap`) |
| **Dual Boot** | Cài đặt và chạy song song 2 hệ điều hành độc lập trên cùng 1 máy tính |
| **Virtual Machine (VM)** | Máy ảo chạy giả lập trên nền hệ điều hành chính (VirtualBox, VMware) |
| **WSL 2 (Windows Subsystem for Linux)** | Hệ thống con Linux phiên bản 2 tích hợp trực tiếp trong Windows |
| **File System Root (`/`)** | Thư mục gốc cao nhất trong cây thư mục của Linux |
| **Home Directory (`~`)** | Thư mục người dùng cá nhân (thường là `/home/<username>`) |
| **Absolute Path** | Đường dẫn tuyệt đối (bắt đầu từ thư mục gốc `/`) |
| **Relative Path** | Đường dẫn tương đối (tính từ vị trí thư mục hiện hành đang đứng) |
| **Terminal / Shell** | Ứng dụng giao diện dòng lệnh (Terminal) và bộ thông dịch lệnh (Shell: Bash, Zsh) |
| **Flag / Option** | Tham số tùy chọn đi kèm câu lệnh (ví dụ: `-l`, `-a`, `-h`) |
| **Alias** | Lệnh rút gọn do người dùng tự định nghĩa trong `~/.bashrc` |
| **Brace Expansion** | Cú pháp mở rộng ngoặc nhọn `{}` để tạo chuỗi/thư mục hàng loạt trong Bash |
| **File Permissions** | Quyền hạn tệp tin (Đọc: `r`, Ghi: `w`, Thực thi: `x`) |
| **Archive vs Compression** | Đóng gói nhiều tệp thành 1 tệp (`tar`) vs Nén giảm kích thước (`gzip`) |
| **LTS (Long Term Support)** | Phiên bản hỗ trợ dài hạn (chu kỳ 5 năm, độ ổn định cao) |

---

### I. TỔNG QUAN BÀI HỌC

* **Khóa học:** Fighting Cancer with Transcriptomics 2026 (FCWT 2026)
* **Chủ đề:** Module 1 – Buổi 02: Giới thiệu môi trường Linux và thao tác tệp tin.
* **Người hướng dẫn:** Trần Quốc Hoàng
* **Tài nguyên học tập:**
  * GitHub Repo: [Fighting_Cancer_with_Transcriptomics](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics)
  * Môi trường thực hành: Google Colab & Terminal máy cá nhân.
* **Lộ trình 3 buổi nền tảng Linux:**
  * **Buổi 02 (Hiện tại):** Khái niệm Linux, cài đặt, điều hướng cây thư mục, thao tác tệp, phân quyền, nén dữ liệu.
  * **Buổi 04 (Tuần tiếp theo):** Các công cụ dòng lệnh cốt lõi trong xử lý dữ liệu tin sinh học (Core Bioinfo Tools).
  * **Buổi 06 (Hai tuần nữa):** Xử lý luồng văn bản (Stream processing) và tự động hóa quy trình (Pipeline automation).

---

### II. TẠI SAO TIN SINH HỌC (BIOINFORMATICS) BẮT BUỘC DÙNG LINUX & CLI?

#### 1. Hạn chế của thao tác chuột trên giao diện đồ họa (GUI)
* **Nguy cơ nhầm lẫn khi dữ liệu lớn:** Tải từng mẫu dữ liệu trên trình duyệt (ví dụ: NCBI) bằng cách bấm chuột rất dễ sai sót, trùng lặp hoặc tải đè tệp tin khi có hàng chục đến hàng trăm mẫu.
* **Tốn kém tài nguyên:** Giao diện đồ họa tiêu tốn nhiều RAM và CPU của hệ thống chỉ để hiển thị cửa sổ.
* **Không thể tự động hóa:** Chuỗi hàng trăm cú nhấp chuột không thể lập trình lặp lại tự động.

#### 2. Ba lợi thế quyết định của Giao diện dòng lệnh (CLI)
1. **Tính tái lập trong nghiên cứu (Reproducibility):**
   * Mọi câu lệnh, tham số và đường dẫn tệp đều được lưu lại trong tệp kịch bản (`.sh`).
   * Khi gửi bài báo khoa học, Reviewer yêu cầu chạy lại hoặc kiểm tra phân tích sau 6–18 tháng, tác giả chỉ cần mở script đã chú thích để tái hiện chính xác 100% kết quả.
2. **Yêu cầu bắt buộc của Hệ thống tính toán hiệu năng cao (HPC / Cloud Server):**
   * Các máy chủ phân tích dữ liệu lớn từ xa hầu như **100% không có giao diện đồ họa (headless)**. Người nghiên cứu bắt buộc phải thao tác qua SSH bằng dòng lệnh.
3. **Môi trường gốc của các công cụ Tin sinh học (Native Environment):**
   * Đa số các phần mềm tin sinh học (như `samtools`, `bwa`, `STAR`, `bedtools`) được thiết kế riêng cho Linux và chạy tối ưu nhất trên nhân Linux.

---

### III. CÁC PHƯƠNG PHÁP CÀI ĐẶT VÀ MÔI TRƯỜNG CHẠY LINUX

| Phương pháp | Bản chất kỹ thuật | Ưu điểm | Nhược điểm / Hạn chế | Khuyến nghị sử dụng |
| :--- | :--- | :--- | :--- | :--- |
| **Dual Boot** | Cài đặt Linux thành hệ điều hành độc lập song song với Windows trên ổ cứng (chọn OS qua menu GRUB khi khởi động). | Tận dụng 100% hiệu năng phần cứng (CPU, GPU, RAM); trải nghiệm Linux native chuẩn mực nhất. | Phải khởi động lại máy khi muốn đổi OS; rủi ro lỗi phân vùng ổ đĩa nếu thao tác sai khi cài đặt. | **Khuyên dùng nhất** cho nghiên cứu chuyên sâu, máy cá nhân lâu dài. |
| **WSL 2** | Nhân Linux thực chạy trực tiếp bên trong hệ điều hành Windows qua cơ chế ảo hóa nhẹ của Microsoft. | Khởi động tức thì; chia sẻ tệp tin giữa Windows và Linux cực kỳ mượt mà; không cần reboot máy. | Hiện tại chỉ hỗ trợ Windows 10/11; đôi khi gặp rào cản phân quyền ổ đĩa hoặc kết nối GPU phức tạp. | **Rất khuyên dùng** cho người dùng Windows muốn học nhanh mà không muốn chia lại ổ đĩa. |
| **Virtual Machine (VMware, VirtualBox)** | Giả lập toàn bộ phần cứng máy tính bên trong một phần mềm chạy trên OS chính. | An toàn tuyệt đối, không sợ hỏng máy chính; dễ tạo và xóa máy ảo thử nghiệm. | Tốn nhiều RAM và CPU chạy nền; hiệu năng xử lý dữ liệu nặng rất chậm; lag giật. | Chỉ phù hợp làm quen ban đầu, **không nên dùng** để phân tích dữ liệu lớn. |
| **Google Colab** | Môi trường máy ảo Linux trên nền đám mây của Google, hỗ trợ GPU miễn phí. | Không cần cài đặt bất cứ thứ gì vào máy cá nhân; truy cập được từ mọi thiết bị qua trình duyệt. | Môi trường tạm thời (Ephemerality) – toàn bộ dữ liệu và phần mềm cài đặt sẽ **bị xóa sạch** khi ngắt kết nối runtime. | Thích hợp cho bài tập thực hành ngắn, demo lớp học; không dùng lưu trữ lâu dài. |

#### Các bản phân phối Linux (Distros) & Trình quản lý gói:
* **Ubuntu (Khuyên dùng cho người mới):** Dựa trên Debian, cộng đồng hỗ trợ lớn nhất, tài liệu phong phú, sử dụng trình quản lý gói `apt` và `snap`.
* **Phân biệt phiên bản Ubuntu:**
  * **LTS (Long-Term Support):** Ví dụ Ubuntu 22.04 LTS, 24.04 LTS. Được hỗ trợ cập nhật 5 năm, cực kỳ ổn định, là lựa chọn chuẩn cho máy phân tích dữ liệu.
  * **Interim Releases:** Cập nhật 6 tháng/lần, hỗ trợ ngắn hạn (9 tháng), chứa phần mềm mới nhất nhưng kém ổn định hơn.
* **Các Distro khác:** Fedora/RHEL (dùng `dnf`), Arch Linux (dùng `pacman`).

---

### IV. CẤU TRÚC HỆ THỐNG TỆP LINUX (FILE SYSTEM NAVIGATION)

#### 1. Cây thư mục và các ký hiệu phím tắt đặc biệt

```
/ (Root - Thư mục gốc cao nhất)
├── bin / sbin     (Chứa các lệnh thực thi nhị phân của hệ thống)
├── etc            (Tệp cấu hình hệ thống)
├── home           (Thư mục người dùng)
│   ├── user1      (Thư mục cá nhân của user1: ~)
│   └── user2      
├── var / tmp      (Dữ liệu biến đổi, tệp tạm thời)
└── mnt / media    (Điểm gắn kết ổ đĩa ngoài, phân vùng Windows)
```

| Ký hiệu | Tên gọi | Ý nghĩa thao tác |
| :---: | :--- | :--- |
| `/` | **Root directory** | Thư mục gốc khởi đầu của toàn bộ hệ thống file |
| `~` | **Home directory** | Đại diện cho thư mục cá nhân của người dùng hiện hành (`/home/<user>`) |
| `.` | **Current directory** | Đại diện cho thư mục hiện hành đang đứng |
| `..` | **Parent directory** | Đại diện cho thư mục mẹ (cấp liền trước) |

#### 2. Đường dẫn tuyệt đối (Absolute) vs Đường dẫn tương đối (Relative)
* **Đường dẫn tuyệt đối (Absolute Path):** Bắt đầu bằng dấu `/`, xác định vị trí cố định từ gốc hệ thống bất kể bạn đang đứng ở đâu (ví dụ: `/home/user/project/data/sample.fastq`).
* **Đường dẫn tương đối (Relative Path):** Tính từ vị trí hiện tại đang đứng, không bắt đầu bằng `/` (ví dụ: đang ở thư mục `project`, đường dẫn tương đối tới tệp là `data/sample.fastq`).

#### 3. Các lệnh điều hướng cơ bản

| Câu lệnh | Cú pháp & Tùy chọn (Flags) | Mô tả chức năng |
| :--- | :--- | :--- |
| `pwd` | `pwd` | In đường dẫn đầy đủ của thư mục hiện hành (*Print Working Directory*) |
| `cd` | `cd <path>` | Chuyển đến thư mục chỉ định (*Change Directory*) |
| | `cd ..` | Lùi về thư mục mẹ cấp trước |
| | `cd ~` hoặc `cd` | Về thẳng thư mục Home của người dùng |
| | `cd -` | Quay lại thư mục vừa đứng trước đó |
| `ls` | `ls` | Liệt kê danh sách tệp tin và thư mục (*List*) |
| | `ls -l` | Hiển thị dạng danh sách chi tiết (quyền, chủ sở hữu, kích thước, ngày sửa) |
| | `ls -a` | Hiển thị tất cả các tệp, bao gồm cả **tệp ẩn** (tệp bắt đầu bằng dấu chấm `.`) |
| | `ls -h` | Hiển thị kích thước tệp định dạng con người dễ đọc (*Human-readable*: KB, MB, GB) |
| | `ls -lah` | Tổ hợp flag được sử dụng nhiều nhất trong thực tế |

#### 4. Kỹ thuật tăng tốc dòng lệnh
* **Tab Completion:** Nhập 1–2 ký tự đầu rồi bấm phím `Tab` để shell tự động điền nốt tên tệp/thư mục. Nhấn `Tab` 2 lần liên tiếp để hiện danh sách các gợi ý trùng tên.
* **Định nghĩa Alias (Lệnh tắt cá nhân):**
  * Thêm lệnh tắt vào tệp `~/.bashrc` hoặc `~/.bash_aliases`:
    ```bash
    alias ll='ls -lah'
    ```
  * Áp dụng thay đổi ngay lập tức mà không cần tắt terminal:
    ```bash
    source ~/.bashrc
    ```
* **Tra cứu tài liệu hướng dẫn nhanh:**
  * Lệnh truyền thống: `man <command>` (hướng dẫn chi tiết đầy đủ).
  * Lệnh tóm tắt tiện ích: `tldr <command>` (*Too Long; Didn't Read* – hiển thị các ví dụ ngắn hay dùng nhất).

---

### V. THAO TÁC QUẢN TRỊ TỆP TIN VÀ THƯ MỤC

#### 1. Tạo và sao chép tệp tin / thư mục
* **Tạo thư mục đa tầng (`mkdir -p`):** Cờ `-p` (*parents*) cho phép tạo cùng lúc thư mục cha và các thư mục con lồng nhau mà không báo lỗi nếu thư mục đã tồn tại:
  ```bash
  mkdir -p project/human_mitochondria/raw_data
  ```
* **Tạo nhanh nhiều thư mục với Brace Expansion `{}`:**
  ```bash
  mkdir -p project/{raw_data,scripts,results,logs}
  ```
* **Tạo tệp rỗng:** `touch filename.txt`
* **Hiển thị trực quan cây thư mục:** Dùng tiện ích `tree`:
  ```bash
  tree project/
  ```
* **Sao chép tệp và thư mục (`cp`):**
  * Sao chép tệp: `cp source.txt destination.txt`
  * Sao chép thư mục: Bắt buộc dùng cờ đệ quy `-r` (*recursive*):
    ```bash
    cp -r folder_source/ folder_backup/
    ```
* **Di chuyển hoặc đổi tên (`mv`):**
  ```bash
  mv old_name.txt new_name.txt        # Đổi tên
  mv sample.fastq raw_data/           # Di chuyển vào thư mục
  ```

#### 2. Xóa dữ liệu an toàn (`rm`)
> [!CAUTION]
> Trong Linux, lệnh `rm` sẽ **xóa vĩnh viễn dữ liệu ngay lập tức**, không đưa vào thùng rác (Trash/Recycle Bin) như Windows hay macOS.

* Xóa tệp có cảnh báo hỏi xác nhận: `rm -i file.txt` (bấm `y` để đồng ý, `n` để hủy).
* Xóa thư mục đệ quy: `rm -r folder_name/`
* **Tuyệt đối không chạy:** Lệnh `rm -rf /` hoặc chạy `rm -rf` với đường dẫn không kiểm tra kỹ.

---

### VI. KIỂM TRA NỘI DUNG TỆP VĂN BẢN (INSPECTING TEXT FILES)

Các định dạng dữ liệu tin sinh học cốt lõi (FASTA, FASTQ, GTF, VCF, SAM) đều là tệp văn bản thuần (plain text).

| Lệnh | Chức năng chính | Ví dụ cú pháp tin sinh học |
| :--- | :--- | :--- |
| `cat` | In toàn bộ nội dung tệp ra màn hình (*Concatenate*). **Chỉ dùng cho tệp nhỏ**. | `cat sample.txt` |
| `head` | Trích xuất $N$ dòng đầu tiên của tệp (mặc định 10 dòng). | `head -n 20 sample.fastq` (Xem 20 dòng đầu) |
| `tail` | Trích xuất $N$ dòng cuối cùng của tệp. | `tail -n 10 run.log` (Xem log kết thúc) |
| `wc -l` | Đếm tổng số dòng văn bản (*Word Count - Lines*). | `wc -l sample.fastq` (Chia 4 sẽ ra số reads giải trình tự) |
| `less` | Trình xem tệp tương tác không tải toàn bộ vào RAM, điều hướng mượt mà. | `less large_dataset.fasta` (Bấm `q` để thoát, mũi tên lên/xuống để duyệt) |

---

### VII. TẢI DỮ LIỆU, PHÂN QUYỀN VÀ NÉN TỆP TIN

#### 1. Tải tệp từ dòng lệnh: `curl` vs `wget`
* **`curl`:** Linh hoạt, mạnh mẽ, mặc định in nội dung ra màn hình. Muốn lưu thành tệp cần cờ `-o` (chỉ định tên tệp):
  ```bash
  curl -o human_mito.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_012920.1&rettype=fasta"
  ```
* **`wget`:** Tự động tải và lưu tệp trực tiếp theo tên gốc từ URL:
  ```bash
  wget "https://example.com/data.zip"
  ```

#### 2. Hệ thống phân quyền tệp (File Permissions)
Khi chạy `ls -l`, mỗi dòng bắt đầu bằng chuỗi 10 ký tự phân quyền (ví dụ: `-rwxr-xr--`), chia thành 4 thành phần:
* **Ký tự 1 (`-` hoặc `d`):** Xác định loại đối tượng (`-`: tệp tin thông thường, `d`: thư mục).
* **Ký tự 2–4 (`rwx`):** Quyền hạn của **Chủ sở hữu (Owner / User)**.
* **Ký tự 5–7 (`r-x`):** Quyền hạn của **Nhóm người dùng (Group)**.
* **Ký tự 8–10 (`r--`):** Quyền hạn của **Người dùng khác trong hệ thống (Others)**.
* **Các quyền cơ bản:** `r` (*Read* - Đọc), `w` (*Write* - Ghi/Sửa), `x` (*Execute* - Thực thi tệp script).
* **Cấp quyền thực thi cho kịch bản:**
  ```bash
  chmod +x download_pipeline.sh
  ./download_pipeline.sh
  ```
* **Thay đổi chủ sở hữu:** Dùng lệnh `chown` (chỉ dùng khi có quyền quản trị viên `sudo` trên server dùng chung).

#### 3. Phân biệt Lưu trữ (Archiving) vs Nén (Compression)
* **Nén tệp đơn lẻ (`gzip`):** Giảm kích thước tệp. Định dạng đầu ra có đuôi `.gz`:
  ```bash
  gzip sample.fastq       # Tạo sample.fastq.gz
  gunzip sample.fastq.gz  # Giải nén trở lại
  ```
* **Đóng gói thư mục (`tar`):** Gộp nhiều tệp/thư mục thành 1 gói duy nhất (*Tape Archive*) nhưng không nén kích thước.
* **Kết hợp đóng gói và nén (`.tar.gz`):** Tiêu chuẩn vàng lưu trữ dữ liệu trong Bioinformatics:
  * Đóng gói và nén thư mục:
    ```bash
    tar -czvf project_backup.tar.gz project/
    ```
    *(Các flag: `-c` tạo mới, `-z` nén gzip, `-v` hiển thị chi tiết, `-f` tên tệp).*
  * Giải nén gói `.tar.gz`:
    ```bash
    tar -xzvf project_backup.tar.gz
    ```
    *(Flag `-x` là extract).*

#### 4. Trình chỉnh sửa văn bản (Text Editors)
* **VS Code (Visual Studio Code):** Trình soạn thảo đồ họa hiện đại, tiện lợi nhất khi làm việc trên máy cá nhân. Mở nhanh thư mục/tệp từ terminal bằng lệnh: `code .`
* **`nano`:** Trình chỉnh sửa dòng lệnh đơn giản, trực quan trên máy chủ từ xa. Thoát bằng phím tắt `Ctrl + X`.
* **`vim`:** Trình biên tập dòng lệnh cổ điển, cực kỳ mạnh mẽ và tối ưu nhưng đòi hỏi học thuộc phím tắt (thoát bằng `:wq` để lưu hoặc `:q!` để hủy).

---

### VIII. TỔNG HỢP PHIÊN HỎI - ĐÁP CHI TIẾT (Q&A SESSION)

1. **Có thể dùng Terminal mặc định của macOS để học và phân tích Bioinfo thay cho Linux được không?**
   * **Trả lời:** Về mặt cú pháp Shell cơ bản (Zsh/Bash), macOS hoàn toàn chạy được các lệnh tương đồng (`cd`, `ls`, `mkdir`). Tuy nhiên, đối với nghiên cứu tin sinh học lâu dài, **khuyên dùng Linux (Dual Boot hoặc WSL 2)** vì:
     * Nhiều công cụ tin sinh chuyên sâu và package Conda chỉ được biên dịch hỗ trợ tối ưu trên nền tảng Linux x86_64, cài trên macOS (đặc biệt chip Apple Silicon M1/M2/M3) rất dễ gặp lỗi xung đột thư viện.
     * Khi làm việc nhóm, việc dùng đồng nhất môi trường Linux giúp kịch bản phân tích chạy đồng bộ, dễ sửa lỗi chéo giữa các thành viên.
2. **Cài đặt Linux Live trên USB rời để chạy thay vì Dual Boot có được không?**
   * **Trả lời:** Có thể khởi động thử nghiệm, nhưng **không khuyến khích dùng để làm việc lâu dài**. Tốc độ đọc/ghi của cổng USB chậm hơn rất nhiều so với ổ cứng gắn trong (SSD NVMe), và việc ghi xóa liên tục khối lượng dữ liệu lớn sẽ làm hỏng thẻ USB, dẫn đến mất mát dữ liệu nghiên cứu.
3. **Bộ gõ tiếng Việt nào hoạt động chuẩn nhất trên các bản phân phối Linux?**
   * **Trả lời:** Nên cài đặt **IBus Bamboo** (`ibus-bamboo`). Đây là bộ gõ mã nguồn mở chuẩn xác nhất trên Linux hiện nay, tương thích tốt với mọi ứng dụng web, Zoom và giao diện màn hình.
4. **Nên lưu trữ câu lệnh và ghi chép học tập bằng Word hay công cụ nào?**
   * **Trả lời:** **Tuyệt đối không lưu code vào Microsoft Word.** Word lưu trữ tệp dạng nhị phân đóng kín (binary `.docx`), nặng nề và không thể đọc được bằng các công cụ dòng lệnh Linux. Nên ghi chép bằng **Markdown (`.md`)** qua các phần mềm như **Obsidian** hoặc **VS Code**.
5. **Cách xử lý khi cài WSL 2 làm đầy dung lượng ổ đĩa `C:` trên Windows?**
   * **Trả lời:** Bản chất WSL 2 lưu trữ toàn bộ hệ thống file trong một tệp đĩa ảo `ext4.vhdx`. Người dùng hoàn toàn có thể dùng lệnh `wsl --export` và `wsl --import` để di dời phân vùng ảo này sang ổ đĩa khác (như ổ `D:` hoặc ổ SSD thứ 2) để giải phóng dung lượng ổ `C:`.
6. **Lưu ý khi sử dụng AI (ChatGPT, Claude, Gemini) hỗ trợ viết mã lệnh:**
   * AI rất hữu ích trong việc gợi ý cú pháp ngắn hoặc gỡ rối (debug) lỗi. Tuy nhiên, người học phải nắm vững kiến thức căn bản để hiểu bản chất câu lệnh. Tránh việc đưa toàn bộ lỗi cho AI sửa khi chưa hiểu lý do, vì AI có thể tự sinh ra các lệnh vòng vo gây hỏng dữ liệu hoặc làm lỗi nghiêm trọng hơn.

---

### IX. TỔNG KẾT BÀI HỌC CỐT LÕI & NGUYÊN TẮC AN TOÀN DÒNG LỆNH

1. **Hiểu rõ câu lệnh trước khi bấm Enter:** Trong Linux, không có hộp thoại xác nhận hủy bỏ hay nút "Undo" cho các thao tác xóa hoặc ghi đè tệp.
2. **Tận dụng phím Tab:** Hạn chế tối đa việc gõ tay toàn bộ tên tệp dài; luôn dùng phím `Tab` để tránh lỗi chính tả.
3. **Phân biệt rạch ròi:**
   * `/` là Gốc hệ thống; `~` là Nhà của bạn; `.` là Nơi bạn đang đứng; `..` là Cấp trên.
   * `gzip` là Nén tệp; `tar` là Gói thư mục; `.tar.gz` là Đóng gói kết hợp nén.
4. **Quy tắc sao lưu (Backup):** Luôn sao lưu dữ liệu quan trọng sang ổ cứng ngoài hoặc Google Drive trước khi thực hiện các thao tác thay đổi phân vùng ổ đĩa hay phân quyền hệ thống.