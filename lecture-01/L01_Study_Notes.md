# TÀI LIỆU HỌC TẬP: KHÓA HỌC FCWT 2026
## BÀI 01: GIỚI THIỆU KHÓA HỌC & NỀN TẢNG GENOMICS / TRANSCRIPTOMICS (PHẦN 1 & PHẦN 2)


---

### Slides: [Google Drive](https://drive.google.com/drive/folders/1n-WbdUA1vVBAxCU-BmbGWOeqyd87TxZ4?usp=sharing)

---

### BẢNG TRA CỨU THUẬT NGỮ CHUYÊN NGÀNH (GLOSSARY)

| Thuật ngữ tiếng Anh | Ý nghĩa / Định nghĩa |
| :--- | :--- |
| **Bulk RNA-seq** | Giải trình tự RNA quần thể tế bào |
| **Single-cell RNA-seq (scRNA-seq)** | Giải trình tự RNA từng tế bào đơn lẻ |
| **Spatial Transcriptomics** | Giải trình tự / phân tích biểu hiện gen có định vị không gian mô |
| **Bash script** | Kịch bản dòng lệnh Linux/Unix (Command Line) |
| **R programming language** | Ngôn ngữ lập trình tính toán thống kê R |
| **ggplot2** | Thư viện trực quan hóa dữ liệu chuẩn xuất bản trong R |
| **NGS (Next-Generation Sequencing)** | Công nghệ giải trình tự thế hệ mới (thông lượng cao) |
| **Sanger sequencing** | Kỹ thuật giải trình tự thế hệ đầu (dựa trên dideoxy chain-termination) |
| **10x Genomics Xenium** | Nền tảng phân tích biểu hiện gen tại chỗ dựa trên chụp ảnh quang học (In situ imaging) |
| **Flow cell** | Hộp vi lưu nơi các đoạn mẫu DNA gắn lên và phản ứng giải trình tự diễn ra |
| **Index / Adapter** | Đoạn nucleotide đánh dấu chỉ mục mẫu để multiplexing và gắn vào flow cell |
| **Read / Reads** | Đoạn đọc trình tự DNA/RNA ngắn thu được từ máy giải trình tự |
| **Contig** | Đoạn trình tự dài liên tục được ghép từ nhiều reads chồng lấn |
| **De novo assembly** | Lắp ráp hệ gen từ đầu mà không cần hệ gen tham chiếu |
| **Reference Genome** | Hệ gen tham chiếu chuẩn đã được giải hoàn chỉnh |
| **IGV (Integrative Genomics Viewer)** | Phần mềm trực quan hóa các đoạn reads căn chỉnh vào hệ gen tham chiếu |
| **PKU (Phenylketonuria)** | Bệnh phenylceton niệu (rối loạn chuyển hóa axit amin Phenylalanine) |
| **PAH (Phenylalanine Hydroxylase)** | Enzyme xúc tác phản ứng chuyển hóa Phenylalanine thành Tyrosine |
| **Diploid ($2n$)** | Thể lưỡng bội (nhận 1 alen từ bố, 1 alen từ mẹ) |
| **Homozygous** | Thể đồng hợp tử |
| **Heterozygous** | Thể dị hợp tử |
| **SNP / SNV** | Đa hình / biến thể đơn nucleotide |
| **Somatic mutation** | Đột biến tế bào soma (thường xuất hiện trong khối u, tỷ lệ alen thấp) |

---

### I. TỔNG QUAN KHÓA HỌC & QUY TRÌNH HỌC TẬP (HOUSEKEEPING)

#### 1. Mục tiêu đào tạo
Khóa học **Fighting Cancer with Genomics / Transcriptomics (FCWT 2026)** được cấu trúc thành **5 modules**, trang bị kiến thức toàn diện từ lý thuyết sinh học đến thực hành phân tích dữ liệu biểu hiện gen trên người, tập trung vào mô ung thư:
1. **Module 1 - Chuẩn bị nền tảng (Bash & R):** Kỹ năng dòng lệnh Linux, thống kê sinh học và trực quan hóa dữ liệu (`ggplot2`).
2. **Module 2 - Bulk RNA-seq:** Đánh giá bức tranh biểu hiện gen tổng thể của mô/khối u.
3. **Module 3 - Single-cell RNA-seq (scRNA-seq):** Phân tích tính dị nguyên (heterogeneity) ở cấp độ từng tế bào đơn, nhận diện các tiểu quần thể tế bào hiếm.
4. **Module 4 - Spatial Transcriptomics:** Bảo tồn tọa độ không gian tế bào trên vi môi trường mô học khối u.
5. **Module 5 - Chuyên đề nâng cao & Seminar:** Các báo cáo ứng dụng thực tế từ các nhà khoa học khách mời (tế bào gốc, miễn dịch, phát triển thuốc đích).

#### 2. Cấu trúc lịch học
* **Tối Thứ Tư (20:00 - 22:00): Kỹ thuật & Lập trình thực chiến**
  * *8–10 tuần đầu:* Nền tảng Command Line (Bash shell) trên Linux, ngôn ngữ R cơ bản, thống kê sinh học ($p\text{-value}$, hypothesis testing), và trực quan hóa dữ liệu chuẩn công bố khoa học (`ggplot2`).
  * *Lý do học dòng lệnh:* Đảm bảo tính lặp lại của nghiên cứu (reproducibility), ghi vết chính xác tham số phân tích để phản biện Reviewer, vượt qua giới hạn của giao diện đồ họa (GUI).
* **Tối Chủ Nhật: Lý thuyết & Ứng dụng y sinh**
  * Bulk RNA-seq (~6 tuần) $\rightarrow$ scRNA-seq (~6 tuần) $\rightarrow$ Spatial Transcriptomics (~4-5 tuần).
  * Phù hợp cả cho các bác sĩ, lab senior không có nhu cầu viết code nhưng cần hiểu sâu để đọc bài báo, diễn giải biểu đồ và thiết kế thí nghiệm.
* **Seminar Chuyên đề Khách mời:** Các buổi báo cáo chuyên sâu 30 phút từ các nhà nghiên cứu về ung thư, tế bào gốc, phát triển thuốc đích.
* **Gặp gỡ On-site & Mạng lưới kết nối:** Khởi động bằng buổi gặp mặt trực tiếp tại Bệnh viện Thống Nhất (TP.HCM) về Spatial Genomics nhằm kết nối cộng đồng nghiên cứu viên và bác sĩ lâm sàng.
* **Ưu thế bản quyền khi xuất bản (Publication):** Khóa học sử dụng hoàn toàn công cụ mã nguồn mở (Linux, R, `ggplot2`). Khi viết bản thảo (manuscript), chỉ cần trích dẫn số hiệu phiên bản mà không cần lo ngại vấn đề giấy phép phần mềm thương mại (như MATLAB hay Excel).

#### 3. Tài nguyên học tập
* **YouTube:** Kênh *Advanced VN Bioinformatics* lưu trữ bài giảng video.
* **GitHub Repository:** [Fighting Cancer with Transcriptomics 2026](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics) chứa mã nguồn, tài liệu và slide.
* **Thực hành:** Google Colab (sử dụng GPU miễn phí) và Google Drive. Dữ liệu thực hành được chọn lọc và downsample (tập trung vào 1–2 nhiễm sắc thể hoặc tập tế bào nhỏ) để tương thích máy cá nhân.

---

### II. TỔNG HỢP GIẢI ĐÁP THẮC MẮC (Q&A SESSION)

1. **Cấu hình máy tính:**
   * RAM khuyến nghị: **16 GB**. Khóa học sẽ downsample dữ liệu (từ 10.000 cells xuống 200–300 cells) để chạy mượt mà trên máy tính cá nhân.
   * Khuyên dùng một hệ điều hành chính (Linux hoặc macOS, hoặc WSL trên Windows), hạn chế Dual Boot phức tạp dễ lỗi phân vùng.
2. **Lựa chọn R hay Python cho Single-cell & Spatial:**
   * Khuyên dùng **R** (hệ sinh thái Bioconductor, Seurat): Đồ họa chuẩn xác, thẩm mỹ cao cho bài báo khoa học; tích hợp sẵn các kiểm định thống kê y sinh.
   * Python (Scanpy) mạnh về khoa học máy tính, tuy nhiên các chỉ số thống kê cần viết script trích xuất thủ công phức tạp hơn.
3. **Định hướng cho người làm thực nghiệm (Wet Lab):**
   * Nếu đề tài chỉ tập trung nuôi cấy, RT-qPCR, tách chiết mà không tự xử lý RNA-seq: Cố gắng theo dõi các buổi Chủ Nhật để nắm bản chất sinh học.
   * Nếu đề tài tốt nghiệp yêu cầu tự xử lý dữ liệu: Bắt buộc đầu tư học thêm về vào code Thứ Tư (sẽ thay đổi sau khi học xong code cơ bản và Bulk RNA-seq).
4. **Học viên nghiên cứu Vi sinh vật (Microbiology):**
   * Khóa này tập trung vào ung thư và hệ gen người. Học viên vi sinh nên tham khảo khóa Metagenomics / Microorganism (khóa [NGMA 2024](https://youtube.com/playlist?list=PLXtgXP89Tyn-cldf3rwqsCh5nR031OD-s&si=Cfgw740E4ruRwvwV) có sẵn trên kênh).
5. **Độ tin cậy của Deconvolution tích hợp dữ liệu GEO công khai:**
   * Khả năng được Reviewer chấp thuận là **50/50**. Nếu không có ít nhất một vài mẫu đơn tế bào thực nghiệm của chính nhóm nghiên cứu để đối chứng chuẩn hóa, việc chỉ giải bulk rồi deconvolution hoàn toàn dựa vào data GEO rất khó bảo vệ.
6. **Định hướng cho học viên ngành Dược (Pharmacy):**
   * Nội dung khóa học tập trung vào hệ gen người và cơ chế biểu hiện gen ung thư. Kiến thức này trực tiếp hỗ trợ việc đọc hiểu cơ chế bệnh sinh, nhận diện gen đích (target discovery) và phát triển thuốc đích (targeted therapy).
7. **Chuyển đổi mã nguồn giữa R và Python trong Dry Lab:**
   * Học viên mới không nên tự chuyển đổi (convert) script/package từ R sang Python. Các hàm và cấu trúc đối tượng (object structure) giữa hai hệ sinh thái không tương đương 1-1, rất dễ sinh lỗi sai lệch kết quả.
8. **Vai trò của AI (Gemini, Claude) trong lập trình tin sinh:**
   * AI hỗ trợ tốt việc gỡ rối (debug), tra cứu tên hàm, gợi ý cú pháp.
   * **Cảnh báo:** Phải tự code thủ công (manual) để hiểu bản chất trước khi dùng AI tự động hóa. Hiểu rõ code còn giúp tránh lãng phí chi phí token khi yêu cầu AI xử lý các tác vụ bất khả thi. Không giao phó toàn bộ cho AI khi chưa đủ kiến thức kiểm chứng tính đúng đắn của thuật toán.

---

### III. BÀI GIẢNG KỸ THUẬT: CÔNG NGHỆ GIẢI TRÌNH TỰ TỪ SANGER ĐẾN NGS

| Tiêu chí so sánh | Sanger Sequencing (Thế hệ 1) | Next-Generation Sequencing (NGS) |
| :--- | :--- | :--- |
| **Bản chất phân tử** | 1 phân tử template đại diện / phản ứng | Hàng triệu – hàng tỷ reads chạy song song |
| **Chiều dài đoạn đọc (Read length)** | Dài (800 – 1000 bp) | Ngắn (100 – 150 bp Paired-End) |
| **Độ sâu / Tỷ lệ đọc (Coverage)** | Đơn lẻ ($1\times$) | Đọc sâu lặp lại nhiều lần ($30\times – 500\times+$) |
| **Độ nhạy phát hiện biến thể** | Thấp (chỉ phát hiện khi biến thể $> 15 – 20\%$) | Rất cao (phát hiện biến thể soma hiếm $1 – 5\%$) |
| **Ứng dụng thực tế** | Kiểm chứng các điểm đột biến rời rạc | Khảo sát toàn diện hệ gen, phát hiện biến thể mới & định lượng biểu hiện gen |

#### 1. Hệ gen người & Các dạng biến thể di truyền
* Hệ gen đơn bội người chứa khoảng $3 \times 10^9$ nucleotide. Hệ gen lưỡng bội ($2n=46$) gồm 1 bộ từ bố và 1 bộ từ mẹ.
* Độ tương đồng giữa hai cá thể người bất kỳ đạt ~99%; 1% còn lại tạo nên khoảng **5 triệu vị trí biến thể**:
  * **SNP / SNV (Single Nucleotide Polymorphism/Variant):** Biến đổi 1 nucleotide (ví dụ: $C \rightarrow T$).
  * **InDel (Insertion/Deletion):** Chèn hoặc mất một hoặc nhiều nucleotide.
  * **CNV (Copy Number Variation):** Thay đổi số lượng bản sao của đoạn gen.
  * **Inversion (Đảo đoạn):** Đoạn ADN bị quay ngược $180^\circ$ ($5' \rightarrow 3'$ đổi chiều).
  * **Translocation (Chuyển đoạn):** Trao đổi đoạn giữa hai nhiễm sắc thể khác nhau hoặc vị trí xa trên cùng NST.

#### 2. Kỹ thuật Sanger (Thế hệ cũ) & Giới hạn
* Dựa trên nguyên lý kết thúc chuỗi (chain termination) với ddNTP nhuộm màu huỳnh quang.
* **Hạn chế:**
  * Mỗi giếng/ống chỉ đọc được 1 tín hiệu đại diện chung của mẫu.
  * Không phát hiện được các đột biến tế bào soma (**somatic mutations**) nếu tỷ lệ tế bào mang đột biến dưới 15–20%. Do đó, Sanger không thể được xem là "tiêu chuẩn vàng" để phủ định kết quả giải trình tự sâu của NGS.

#### 3. Bài toán De novo Assembly (Lắp ráp từ đầu) vs Reference Mapping
* **Lắp ráp từ đầu (De novo assembly):**
  * Cắt ADN thành các mảnh nhỏ, giải trình tự thành các đoạn đọc (**reads**), sau đó đối chiếu từng cặp reads để tìm vùng chồng lấn (**overlap**) nhằm ghép thành các chuỗi dài (**contigs**).
  * **Độ phức tạp tính toán:** Khi có $N$ đoạn reads, cần so sánh cặp đôi với chi phí tỷ lệ với $O(N^2)$. Với hệ gen người đòi hỏi hàng trăm triệu reads, chi phí tính toán bùng nổ cực lớn.
  * **Nguy cơ nhiễm tạp:** Mẫu sinh học (nước bọt, máu) luôn chứa vi sinh vật tạp nhiễm. Khi lắp ráp De novo mù mờ không có mẫu đối chiếu, các đoạn reads tạp nhiễm dễ bị ghép sai vào hệ gen đích.
* **Căn chỉnh với Hệ gen tham chiếu (Reference Mapping):**
  * Sau khi Dự án Hệ gen Người (năm 2000) hoàn thành bản đồ chuẩn với chi phí 3 tỷ USD, công nghệ NGS chuyển sang bài toán mapping.
  * Các đoạn reads ngắn (100–150 bp) được gióng thẳng vào tọa độ tương ứng trên Reference Genome.
  * **Độ phức tạp tính toán giảm xuống $O(N)$:** Mỗi read chỉ cần tìm vị trí phù hợp trên bản tham chiếu. Các reads tạp nhiễm từ vi khuẩn sẽ không map vào hệ gen người và bị loại bỏ dễ dàng.
  * *Hình ảnh ẩn dụ:* De novo assembly giống như xếp hình puzzle mà không có bức tranh mẫu; Reference mapping giống như có bức tranh mẫu gốc để đặt từng mảnh ghép vào đúng vị trí.

#### 4. Cơ chế hoạt động của NGS (Illumina Sequencing by Synthesis)
* **Nguồn tách chiết ADN trong mẫu máu:** Hồng cầu người là tế bào không có nhân nên không chứa ADN. Toàn bộ ADN thu được từ mẫu máu đến từ các tế bào bạch cầu có nhân (bạch cầu hạt, tế bào lympho T, B, NK...). 1 ml máu chứa hàng triệu tế bào bạch cầu, cung cấp hàng triệu bản sao hệ gen.
* **Ẩn dụ chuẩn bị thư viện xưa và nay:** Chuẩn bị mẫu trước đây giống như tự làm bánh xèo từ đầu (ngâm gạo, tìm cối xay bột, dòng hóa vào vector plasmid, biến nạp vi khuẩn E. coli/nấm men); hiện nay các kit thương mại có sẵn enzyme và index như bột pha sẵn, rút ngắn tối đa thời gian thao tác.
* **Xây dựng Reference Genome mới:** Với các sinh vật chưa có bản đồ chuẩn (ví dụ cây sầu riêng), chi phí giải de novo reference genome hiện nay rất dễ tiếp cận (~8–16 triệu VNĐ cho độ phủ $20\times - 100\times$), làm bản mẫu phục vụ toàn bộ các phân tích mapping về sau.

1. **Chuẩn bị thư viện (Library Preparation):** ADN được phân mảnh nhỏ (~300–500 bp), gắn các chuỗi adapter/index nhân tạo ở hai đầu nhờ enzyme kit thương mại (không cần dòng hóa vi khuẩn như trước).
2. **Gắn lên Flow cell:** Các đoạn ADN lai với các đoạn mồi cố định trên bề mặt flow cell.
3. **Giải trình tự bằng tổng hợp (Sequencing by Synthesis - SBS):**
   * Các dNTP đánh dấu huỳnh quang hồi phục (reversible terminator) được đưa vào tổng hợp sợi bổ sung từng nucleotide một.
   * Máy quét quang học chụp ảnh ghi nhận màu huỳnh quang phát ra tại từng cụm phân tử trên flow cell.
   * Nhóm chặn và chất huỳnh quang được giải phóng, lặp lại chu kỳ cho nucleotide tiếp theo.
   * Dữ liệu thô xuất ra dưới định dạng file **FASTQ**.
4. **Trực quan hóa trên phần mềm IGV (Integrative Genomics Viewer):**
   * Các reads màu xám thể hiện trình tự trùng khớp với Reference Genome.
   * Các vạch màu khác biệt (ví dụ vạch đỏ đại diện cho T thay vì A ở Reference) thể hiện vị trí biến thể.
   * Tỷ lệ đọc sâu (Read depth) cho biết biến thể ở trạng thái đồng hợp tử (gần 100% reads mang alen mới) hay dị hợp tử (~50% reads mang alen mới).

---

### IV. ỨNG DỤNG DNA-SEQ: PHÁT HIỆN BIẾN THỂ & CƠ CHẾ BỆNH HỌC

* **Mối liên hệ nhân quả Gen – Bệnh (Ví dụ bệnh PKU - Phenylketonuria):**

| Trạng thái | ADN (Gen *PAH*) | Phiên mã (mARN) | Dịch mã & Hoạt tính Enzyme | Hậu quả sinh hóa & Kiểu hình |
| :--- | :--- | :--- | :--- | :--- |
| **Bình thường** | Trình tự chuẩn (Alen T) | Codon chuẩn (AUA mã hóa Isoleucine) | Enzyme PAH hoạt động bình thường | Xúc tác chuyển hóa Phenylalanine (Phe) $\rightarrow$ Tyrosine (Tyr) |
| **Đột biến** | Đột biến thay thế ($T \rightarrow A$) | Codon biến đổi (AAA mã hóa Aspartate) | Enzyme PAH sai hỏng cấu trúc, mất hoạt tính | Không chuyển hóa được Phe $\rightarrow$ Ứ đọng Phenylalanine gây độc thần kinh (bệnh PKU) |

* Giải trình tự ADN giúp phát hiện sớm và chính xác các biến thể nguyên nhân trước khi các tổn thương lâm sàng xuất hiện.

---

### V. BẢN CHẤT CỦA RNA-SEQ: ĐỊNH LƯỢNG MỨC ĐỘ BIỂU HIỆN GEN

| Tiêu chí so sánh | DNA-seq | RNA-seq |
| :--- | :--- | :--- |
| **Mục tiêu cốt lõi** | Tìm **biến thể di truyền** (Đột biến, SNP, InDel, CNV) | **Định lượng biểu hiện gen** (Mức độ phiên mã cao hay thấp) |
| **Độ phủ / Độ sâu (Coverage)** | Rất cao ($30\times – 100\times+$) | Thường nông ($10\times – 15\times$) hoặc đếm số lượng reads |
| **Độ bền phân tử mẫu** | Rất bền, chịu được nhiệt độ phòng ($25 – 30^\circ\text{C}$) | Rất kém bền, dễ phân hủy bởi RNase, cần bảo quản lạnh âm sâu |
| **Cơ chế phân tích** | Xác định ký tự ($A, C, T, G$) khác biệt so với Reference | **Đếm số lượng reads (Read Count)** map vào từng locus gen |

#### 1. Vì sao không dùng RNA-seq để tìm đột biến?
* Phân tử RNA rất kém bền, dễ bị đứt gãy bởi enzyme RNase có sẵn trong mồ hôi, môi trường. Vận chuyển mẫu RNA đòi hỏi đá khô/nhiệt độ âm sâu khắt khe.
* Độ bao phủ (Coverage) của RNA-seq thường nông (~10x–15x) và chỉ phản ánh những gen đang hoạt động trong mô tại thời điểm thu mẫu, không bao quát toàn bộ hệ gen. Do đó, tìm đột biến trên ADN luôn kinh tế, ổn định và đáng tin cậy hơn.

#### 2. Cơ chế định lượng của RNA-seq (Counting Reads)
* Mặc dù máy NGS giải ra trình tự nucleotide (A, C, T, G), nhưng trong RNA-seq, thông tin trình tự chủ yếu được dùng làm "thẻ định danh" để map read về đúng vị trí gen nguồn trên hệ gen.
* **Nguyên lý:** Mức độ biểu hiện của gen tỷ lệ thuận với số lượng phân tử bản sao mARN trong tế bào $\rightarrow$ Tỷ lệ thuận với số lượng đoạn reads thu được tương ứng với gen đó.
* **So sánh định lượng: RNA-seq vs RT-qPCR:**
  * **RT-qPCR (Quantitative PCR):** Là phương pháp định lượng truyền thống, độ nhạy cao nhưng thông lượng thấp (chỉ đo được vài gen đích rời rạc).
  * **RNA-seq (Next-Gen Sequencing):** Định lượng đồng thời toàn bộ hệ phiên mã (**~20.000 – 25.000 gen** cùng lúc) mà không cần mồi đặc hiệu trước đó, giúp phát hiện cả các gen mới và biến đổi đồng dạng (isoforms).
* **Quy trình định lượng:**
  1. Gióng hàng (Alignment) reads vào Reference Transcriptome/Genome.
  2. Đếm số reads map vào từng gen (tạo bảng **Count Matrix**: Dòng là Gen, Cột là Mẫu/Tế bào).
  3. Phân tích biểu hiện khác biệt (**Differential Gene Expression - DEG**): So sánh số đếm giữa nhóm Bệnh (Khối u) vs nhóm Chứng (Mô lành) để tìm ra các gen tăng sinh (Up-regulated) hoặc suy giảm (Down-regulated).

#### 3. Đối tượng nghiên cứu: mRNA có đuôi Poly(A)
* Trong tế bào, phần lớn RNA là rRNA (RNA ribosome chiếm >80%) và tRNA.
* Khóa học tập trung vào **mRNA** (RNA thông tin mã hóa protein). Trong quá trình chuẩn bị thư viện, các hạt từ gắn mồi oligo(dT) được dùng để bắt giữ đặc hiệu phần đuôi **poly(A)** của phân tử mRNA, loại bỏ nền nhiễu từ rRNA.

---

### TỔNG KẾT BÀI HỌC CỐT LÕI
1. **Lập trình là công cụ ghi nhớ và tái lập:** Học Bash & R giúp kiểm soát tham số nghiên cứu, phục vụ viết phần *Method* và phản biện xuất bản (tận dụng công cụ mã nguồn mở miễn phí, tránh rủi ro bản quyền như MATLAB).
2. **NGS là công nghệ song song:** Chuyển đổi từ mô hình đơn lẻ (Sanger) sang hàng triệu reads song song trên Flow cell, giảm độ phức tạp từ $O(N^2)$ (De novo) xuống $O(N)$ (Reference Mapping).
3. **DNA-seq = Variant Calling; RNA-seq = Gene Expression Quantification:** Hiểu rõ mục tiêu để lựa chọn đúng công nghệ giải trình tự, độ phủ và phương pháp xử lý tin sinh học phù hợp.

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học FCWT 2026. Tài liệu phục vụ mục đích học tập và tham khảo.
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.
