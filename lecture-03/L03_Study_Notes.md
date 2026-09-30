# TÀI LIỆU HỌC TẬP: KHÓA HỌC FCWT 2026
## BÀI 03: NỀN TẢNG GIẢI TRÌNH TỰ BULK RNA-SEQ & THIẾT KẾ THÍ NGHIỆM (BULK RNA-SEQ FOUNDATIONS & EXPERIMENTAL DESIGN)

---

### BẢNG TRA CỨU THUẬT NGỮ CHUYÊN NGÀNH (GLOSSARY)

| Thuật ngữ tiếng Anh | Ý nghĩa / Định nghĩa |
| :--- | :--- |
| **Bulk RNA-seq** | Giải trình tự RNA tổng thể từ một khối mô (hỗn hợp không đồng nhất của nhiều loại tế bào) |
| **Single-cell RNA-seq (scRNA-seq)** | Giải trình tự RNA ở độ phân giải từng tế bào đơn lẻ |
| **Spatial Transcriptomics** | Giải trình tự định lượng biểu hiện gen kết hợp tọa độ không gian mô học |
| **Central Dogma** | Học thuyết trung tâm của sinh học phân tử ($DNA \rightarrow RNA \rightarrow Protein$) |
| **Tissue Heterogeneity** | Tính không đồng nhất của mô (mẫu mô bao gồm tế bào khối u, tế bào miễn dịch, nguyên bào sợi, mạch máu) |
| **Total RNA** | RNA tổng số thu nhận sau quá trình ly trích (chứa mRNA, rRNA, tRNA, lncRNA, snRNA...) |
| **mRNA (Messenger RNA)** | RNA thông tin mang mã di truyền để dịch mã tổng hợp protein (chỉ chiếm <3% tổng lượng RNA) |
| **rRNA (Ribosomal RNA)** | RNA ribosome cấu tạo nên bào quan dịch mã (chiếm ~80–90% tổng lượng RNA tế bào) |
| **Poly-A Selection** | Phương pháp bắt chọn mRNA có đuôi poly-A bằng hạt từ gắn chuỗi oligo-dT |
| **rRNA Depletion (Ribo-Zero)** | Phương pháp loại bỏ chọn lọc rRNA bằng lai đầu dò và phân giải enzyme |
| **cDNA (Complementary DNA)** | Phân tử DNA bổ sung được tổng hợp từ mạch khuôn RNA qua enzyme Reverse Transcriptase |
| **Reverse Transcription (RT)** | Quá trình phiên mã ngược biến đổi RNA thành cDNA để giải trình tự trên máy NGS |
| **Flow Cell** | Bản vi lưu trên máy giải trình tự Illumina nơi các cụm đoạn đọc (clusters) được nhân bản và giải trình tự |
| **Read Alignment / Mapping** | Quá trình đối chiếu các đoạn đọc ngắn (reads) lên hệ gen hoặc hệ phiên mã tham chiếu |
| **BAM (Binary Alignment Map)** | Định dạng nhị phân nén lưu trữ kết quả căn hàng các đoạn đọc trên hệ gen |
| **Read Count / Count Matrix** | Bảng đếm số lượng đoạn đọc ánh xạ thành công vào từng gen qua các mẫu thí nghiệm |
| **Normalization** | Chuẩn hóa dữ liệu đếm nhằm loại bỏ sai lệch kỹ thuật (độ sâu đọc, độ dài gen, hiệu ứng mẻ) |
| **Differential Expression (DGE)** | Phân tích so sánh mức độ biểu hiện gen khác biệt có ý nghĩa thống kê giữa các nhóm mẫu |
| **Biological Replicate** | Mẫu lặp sinh học (mẫu lấy từ các cá thể hoặc hệ thống sinh học độc lập khác nhau) |
| **Technical Replicate** | Mẫu lặp kỹ thuật (cùng 1 mẫu sinh học nhưng chia nhỏ ra làm thư viện/chạy máy nhiều lần) |
| **Sequencing Depth / Coverage** | Độ sâu giải trình tự (tổng số lượng reads tạo ra cho mỗi mẫu, ví dụ 20M–50M reads) |
| **Phred Quality Score (Q-score)** | Thang đo logarit biểu thị xác suất đọc sai của từng nucleotide ($Q30 \Rightarrow$ độ chính xác 99.9%) |
| **Alternative Splicing** | Quá trình cắt nối luân phiên các exon tạo nên nhiều phân tử transcript khác nhau từ cùng một gen |
| **Transcript** | Phân tử RNA thành phẩm cụ thể được tạo ra từ quá trình phiên mã và cắt nối |
| **Protein Isoform** | Các biến thể protein chức năng khác nhau được dịch mã từ các transcript của cùng một gen |
| **MANE Select** | Chuẩn chú giải transcript đại diện chính thống nhất giữa hai cơ sở dữ liệu NCBI và EMBL-EBI |
| **Fusion Gene** | Gen dung hợp hình thành do tái sắp xếp cấu trúc nhiễm sắc thể (chuyển đoạn, mất đoạn, đảo đoạn) |
| **RT-qPCR** | Kỹ thuật PCR phiên mã ngược thời gian thực dùng để xác thực độc lập biểu hiện gen |

---

### I. TỔNG QUAN BÀI HỌC

* **Khóa học:** Fighting Cancer with Transcriptomics 2026 (FCWT 2026).
* **Chủ đề:** Module 1 – Buổi 03: Nền tảng Bulk RNA-seq & Thiết kế thí nghiệm (Bulk RNA-seq Foundations & Experimental Design).
* **Giảng viên hướng dẫn:** Thầy Lưu Phúc Lợi.
* **Mục tiêu cốt lõi:**
  1. Hiểu rõ bản chất sinh học và kỹ thuật của Bulk RNA-seq, phân biệt với DNA-seq và RNA-seq.
  2. Nắm vững luồng xử lý toàn diện từ mẫu mô thực tế $\rightarrow$ ly trích RNA $\rightarrow$ thư viện cDNA $\rightarrow$ căn hàng BAM $\rightarrow$ ma trận đếm số đọc (Count matrix).
  3. Phân biệt chính xác giữa Transcript và Protein Isoform, cơ chế cắt nối luân phiên (Alternative Splicing).
  4. Nắm vững nguyên tắc thiết kế thí nghiệm chuẩn: ý nghĩa quyết định của mẫu lặp sinh học ($N \ge 3$), đối trọng giữa độ sâu đọc và số lượng mẫu.
  5. Đánh giá chất lượng dữ liệu: Phred score Q30, kiểm soát tạp nhiễm và xác thực độc lập bằng RT-qPCR.

---

### II. BẢN CHẤT CỦA BULK RNA-SEQ & SO SÁNH CÁC TẦNG DỮ LIỆU OMICS

#### 1. Khái niệm Bulk RNA-seq & Tính không đồng nhất của mô (Tissue Heterogeneity)
* **Bulk ("một cục / hỗn hợp"):** Mẫu sinh thiết lâm sàng (ví dụ mô ung thư vú, khối u phổi) không bao giờ là một quần thể tế bào đồng nhất thuần khiết.
* **Thành phần tế bào trong một khối mô bulk:**
  * Tế bào khối u (Tumor cells).
  * Tế bào miễn dịch thâm nhiễm (TILs: T-cells, B-cells, đại thực bào).
  * Nguyên bào sợi liên kết (Cancer-associated fibroblasts - CAFs).
  * Tế bào nội mô mạch máu (Endothelial cells).
* **Hệ quả phân tích:** Dữ liệu Bulk RNA-seq ghi nhận **giá trị trung bình gộp (ensemble average)** biểu hiện gen của toàn bộ các loại tế bào có mặt trong mẫu.

#### 2. Bảng so sánh 3 tầng phân tử: DNA-seq vs RNA-seq vs Proteomics

| Tiêu chí | DNA Sequencing (Genomics) | RNA Sequencing (Transcriptomics) | Mass Spectrometry (Proteomics) |
| :--- | :--- | :--- | :--- |
| **Bản chất phân tử** | Hệ gen tĩnh (Static Blueprint). | Bản sao phiên mã động (Dynamic Snapshot). | Phân tử thực thi chức năng tế bào (Phenotypic Effectors). |
| **Tính biến thiên theo tế bào** | Hầu như đồng nhất ở mọi tế bào trong cùng một cơ thể (trừ đột biến sinh dưỡng somatic). | Thay đổi mạnh mẽ theo loại tế bào, giai đoạn biệt hóa và điều kiện môi trường. | Rất động, chịu ảnh hưởng bởi dịch mã và biến đổi sau dịch mã (PTMs). |
| **Mục tiêu phân tích chính** | Tìm biến thể di truyền: SNP, Indel, biến thể cấu trúc (SV), đột biến số bản sao (CNV). | Định lượng mức độ biểu hiện gen (Count data), tìm gen biểu hiện sai khác (DGE), cắt nối (Splicing). | Định lượng hàm lượng protein, tương tác protein-protein, biến đổi sau dịch mã. |
| **Bản chất phép đo** | Nhị phân / Tần số alen (Alen tham chiếu vs Alen đột biến: 0, 0.5, 1). | **Định lượng liên tục** (Continuous quantitative counts từ 0 đến hàng trăm nghìn reads). | Cường độ ion phổ khối (Ion intensity), bán định lượng. |
| **Chi phí & Độ phủ** | ~$300–$1000/mẫu (phụ thuộc WES hay WGS). | Rất rẻ: **~$200–$250/mẫu** cho toàn bộ transcriptome (~20.000–26.000 gen). | Rất đắt đỏ, phức tạp kỹ thuật, khó khảo sát toàn diện hàng chục nghìn protein cùng lúc. |
| **Độ tái lập kỹ thuật** | Rất cao, ổn định cao. | **Cao, quy chuẩn hóa tốt**, dễ kiểm tra chéo bằng RT-qPCR. | Trung bình, tính lặp lại giữa các phòng thí nghiệm còn nhiều biến thiên. |

---

### III. QUY TRÌNH TOÀN DIỆN TỪ WET-LAB ĐẾN MA TRẬN ĐẾM (COUNT MATRIX)

```
[Mẫu sinh học (Bulk Tissue)]
         │
         ▼
[Ly trích Total RNA] ───(Kiểm tra độ nguyên vẹn: RIN score, NanoDrop, Bioanalyzer)
         │
         ▼
[Lọc chọn lọc RNA] ──┬──> Poly-A Selection (Bắt mRNA bằng Oligo-dT beads)
                     └──> rRNA Depletion (Ribo-Zero loại bỏ rRNA >80-90%)
         │
         ▼
[Phân mảnh RNA & Phiên mã ngược (RT)] ───(Tạo cDNA mạch 1 & mạch 2)
         │
         ▼
[Gắn Adapter & Chỉ số Index / Barcode] ───(Tạo thư viện giải trình tự hoàn chỉnh)
         │
         ▼
[Giải trình tự trên Flow Cell (Illumina)]
         │
         ▼
[Tệp thô FASTQ] ───(Đánh giá QC: FastQC, lọc sạch adapter, kiểm tra Phred Q30)
         │
         ▼
[Căn hàng (Alignment / Splice-aware Mapping)] ───(STAR, HISAT2 đối chiếu Reference Genome)
         │
         ▼
[Tệp căn hàng BAM / SAM]
         │
         ▼
[Đếm đoạn đọc (Read Counting)] ───(featureCounts, HTSeq đếm reads rơi vào từng Exon/Gen)
         │
         ▼
[Ma trận đếm thô (Raw Count Matrix)] ───> [Normalization] ───> [Phân tích DGE (DESeq2 / edgeR)]
```

#### 1. Tại sao máy giải trình tự không thể đọc trực tiếp RNA?
* Các hệ thống NGS hiện đại (như Illumina) chỉ nhận diện chuỗi nucleotide sợi đôi DNA thông qua quá trình tổng hợp kết hợp huỳnh quang (Sequencing-by-Synthesis).
* **Bắt buộc:** Phải chuyển đổi phân tử RNA đích thành mạch bổ sung cDNA bằng enzyme phiên mã ngược (**Reverse Transcriptase**).

#### 2. Chiến lược xử lý Total RNA: Poly-A Selection vs rRNA Depletion
* Trong tế bào, **rRNA chiếm hơn 80–90%** tổng lượng RNA, trong khi mRNA mã hóa cho protein chỉ chiếm **ít hơn 3%** (~9 triệu phân tử trên tổng số ~3 tỷ nucleotide phiên mã).
* Nếu không lọc bỏ rRNA, hơn 90% số reads giải trình tự sẽ bị lãng phí vào các chuỗi ribosome lặp lại vô nghĩa.
* **Hai giải pháp chuẩn:**
  1. **Poly-A Selection:** Dùng hạt từ gắn đoạn mồi Oligo-dT để bắt giữ đuôi Poly-A đặc trưng của mRNA trưởng thành.
     * *Hạn chế:* Không bắt được các non-coding RNA không có đuôi poly-A; không dùng được cho mẫu RNA thoái hóa/đứt gãy (FFPE) hoặc mẫu vi khuẩn.
  2. **rRNA Depletion (Ribo-Zero):** Sử dụng các đoạn dò bổ sung với rRNA của sinh vật, sau đó phân giải bằng RNase H để giữ lại toàn bộ các loại RNA khác (mRNA + lncRNA + circular RNA). Phù hợp cho mẫu mô lưu trữ lâu ngày hoặc nghiên cứu non-coding RNA.

#### 3. Căn hàng lên hệ gen & Cơ chế đếm số đọc (Read Counting)
* Khác với Sanger (đọc 1 lần ra 1 chuỗi), công nghệ NGS đọc hàng triệu mảnh rời rạc song song.
* Mức độ biểu hiện của một gen tỷ lệ thuận với số lượng phân tử mRNA của gen đó trong tế bào $\Rightarrow$ tạo ra càng nhiều đoạn cDNA $\Rightarrow$ máy ghi nhận **càng nhiều reads ánh xạ (map) vào tọa độ exon của gen đó**.
* **Định dạng dữ liệu:**
  * **FASTQ:** Lưu chuỗi ký tự đọc và điểm chất lượng Phred ($Q$).
  * **BAM:** Lưu tọa độ vị trí chính xác của từng read trên các nhiễm sắc thể.
  * **Count Matrix:** Bảng 2 chiều ($Gene \times Sample$) ghi nhận số nguyên reads ánh xạ.

---

### IV. THIẾT KẾ THÍ NGHIỆM: QUY TẮC MẪU LẶP VÀ ĐỘ SÂU GIẢI TRÌNH TỰ

#### 1. Quy tắc tối thượng: Mẫu lặp sinh học ($N \ge 3$)
* **Sai lầm phổ biến:** Chỉ làm 1 mẫu bệnh đối đầu với 1 mẫu chứng ($N = 1$ vs $N = 1$), hoặc chỉ làm $N = 2$.
* **Hạn chế của $N = 1$:** Không thể phân biệt được sự chênh lệch biểu hiện là do bản chất bệnh lý hay do:
  1. Biến thiên sinh học ngẫu nhiên giữa các cá thể.
  2. Nhiễm tạp chất hoặc thao tác ly trích lỗi ở mẫu đơn đó.
  3. Lỗi kỹ thuật máy giải trình tự.
* **Tại sao không nên dùng số chẵn ($N = 2$)?** Nếu mẫu 1 cho giá trị 100, mẫu 2 cho giá trị 160, kiểm định thống kê hoàn toàn bất lực vì không thể xác định mẫu nào mang giá trị lệch chuẩn (outlier).
* **Khuyến nghị chuẩn quốc tế:**
  * **Ít nhất 3 mẫu lặp sinh học độc lập ($N \ge 3$)** cho mỗi nhóm thí nghiệm.
  * Trong các mô hình phức tạp hoặc mẫu lâm sàng trên người (vốn có độ dao động sinh học rất lớn), khuyến nghị nâng lên **$N = 5, 7, 9$**.

#### 2. Biological Replicates vs Technical Replicates

| Đặc điểm | Mẫu lặp sinh học (Biological Replicates) | Mẫu lặp kỹ thuật (Technical Replicates) |
| :--- | :--- | :--- |
| **Định nghĩa** | Lấy mẫu từ các cá thể chuột, bệnh nhân hoặc đĩa nuôi cấy độc lập. | Chia cùng một ống dịch ly trích RNA ra thành nhiều ống để chuẩn bị thư viện/chạy máy riêng biệt. |
| **Giá trị thống kê** | **Rất cao**: Đo lường và kiểm soát được độ biến thiên thực tế trong tự nhiên. | Thấp: Chỉ đo độ chính xác của thao tác pipet và thiết bị máy móc. |
| **Ứng dụng** | Bắt buộc phải có để phân tích biểu hiện vi sai (DGE) có ý nghĩa xuất bản bài báo khoa học. | Chỉ cần thiết khi kiểm tra quy trình công nghệ mới hoặc mẫu vô cùng quý hiếm (khảo cổ, ca bệnh cực hiếm). |

#### 3. Độ sâu giải trình tự (Sequencing Depth) vs Số lượng mẫu lặp
* **Định đề thống kê:**
  $$\text{Tăng số mẫu lặp sinh học (Statistical Power)} \gg \text{Tăng độ sâu đọc quá mức trên 1 mẫu}$$
* **Thực nghiệm chứng minh:**
  * Chạy **3 mẫu lặp sinh học với độ sâu $30\times$ (hoặc 20M reads/mẫu)** đem lại độ chính xác thống kê vượt trội hoàn toàn so với chạy **1 mẫu duy nhất ở độ sâu $90\times$ (hoặc 60M reads)**.
* **Độ sâu khuyến nghị cho Bulk RNA-seq:**
  * **Định lượng biểu hiện gen cơ bản:** 20 triệu đoạn đọc đôi (20 Million Paired-End reads - `PE150`).
  * **Khảo sát cắt nối luân phiên / gen biểu hiện thấp:** 40M – 50M Paired-End reads.

---

### V. TRANSCRIPT VS PROTEIN ISOFORM & HỆ THỐNG ĐIỀU HÒA SINH HỌC

#### 1. Phân biệt cấp độ phân tử

```
[Gen trên DNA] (Chứa Promoter, Exons, Introns xen kẽ)
      │
      ▼ (Phiên mã)
[Pre-mRNA] (Chưa trưởng thành, còn nguyên Intron)
      │
      ▼ (Cắt nối luân phiên - Alternative Splicing)
┌─────────────────────────────────┬─────────────────────────────────┐
▼                                 ▼                                 ▼
[Transcript 1 (Exon 1-2-3-4)]     [Transcript 2 (Exon 1-2-4)]       [Transcript 3 (Exon 1-3-4)]
│ (Gắn mũ 5' Cap & đuôi Poly-A)   │                                 │
▼                                 ▼                                 ▼
[Dịch mã tại Ribosome]            [Dịch mã tại Ribosome]            [Dịch mã tại Ribosome]
│                                 │                                 │
▼                                 ▼                                 ▼
[Protein Isoform A]               [Protein Isoform B]               [Protein Isoform C]
```

* **Transcript (Mức độ RNA):** Là chuỗi phân tử mRNA thành phẩm sau khi hoàn tất loại bỏ intron và ghép các exon. Cùng 1 gen có thể tạo ra nhiều transcript khác nhau nhờ cắt nối luân phiên.
* **Protein Isoform (Mức độ Protein):** Các dạng biến thể protein chức năng được dịch mã từ các transcript khác nhau của cùng 1 gen.

#### 2. Ý nghĩa chức năng của các Transcripts trong Ung thư
* Cùng một gen nhưng các transcript khác nhau có thể mang hoạt tính đối nghịch sinh học:
  * **Transcript 1:** Đóng vai trò gen sinh ung (**Oncogene**), thúc đẩy tế bào phân chia kháng thuốc.
  * **Transcript 2:** Đóng vai trò gen đè nén bướu (**Tumor Suppressor Gene**), kích hoạt quá trình chết theo chương trình (Apoptosis).
* Biểu hiện transcript phụ thuộc nghiêm ngặt vào:
  * **Loại tế bào (Cell type):** Tế bào thần kinh biểu hiện transcript A, tế bào biểu mô da biểu hiện transcript B.
  * **Giai đoạn biệt hóa:** Tế bào gốc đầu dòng thần kinh (neural progenitors) chuyển sang neuron trưởng thành sẽ thay đổi hoàn toàn transcript chiếm ưu thế.

#### 3. Chuẩn hóa chú giải: MANE Select (Matched Annotation from NCBI and EMBL-EBI)
* Trước đây, NCBI (RefSeq) và Ensembl/GENCODE gán tên và cấu trúc transcript lệch nhau, gây hỗn loạn khi đối chiếu dữ liệu y sinh.
* **Dự án MANE (MANE Select):** Thống nhất một transcript chuẩn đại diện duy nhất cho mỗi gen mã hóa protein ở người:
  * Thường là transcript có chiều dài đầy đủ nhất, chứa đầy đủ các exon chức năng phổ quát.
  * Dùng làm hệ quy chiếu tiêu chuẩn để báo cáo các biến thể gây bệnh trong lâm sàng.

---

### VI. KIỂM SOÁT CHẤT LƯỢNG (QC) & PHÁT HIỆN TẠP NHIỄM

#### 1. Thang điểm chất lượng Phred (Phred Quality Score - $Q$)
* Công thức tính xác suất đọc sai ký tự ($P$):
  $$Q = -10 \log_{10}(P)$$
* **Tiêu chuẩn công nghiệp:**
  * **$Q20$:** Xác suất lỗi $1/100$ (Độ chính xác 99%).
  * **$Q30$:** Xác suất lỗi $1/1000$ (Độ chính xác 99.9%).
* **Quy tắc thực nghiệm:** Các máy giải trình tự hiện đại cam kết $\ge 96\%$ số nucleotide đạt từ **$Q30$ trở lên**. Nếu biểu đồ chất lượng ở đầu 3' hoặc 5' tụt xuống dưới 30, bắt buộc phải dùng công cụ cắt tỉa (Trimming) loại bỏ trước khi căn hàng.

#### 2. Nguyên nhân suy giảm chất lượng và tạp nhiễm
* **Suy giảm chất lượng ở đầu 3':** Do cạn kiệt hóa chất dNTP và enzyme suy giảm hoạt tính ở các chu kỳ tổng hợp cuối của dòng chảy Illumina.
* **Nhiễm rRNA:** Do quá trình xử lý hạt Poly-A hoặc enzyme loại bỏ ribosome ở khâu Wet-lab chưa triệt để $\Rightarrow$ Kiểm tra trên FastQC/MultiQC thấy xuất hiện tỷ lệ reads cao bất thường khớp với các gen rRNA (18S, 28S).
* **Nhiễm DNA/RNA vi khuẩn:** Mẫu sinh thiết mô bị nhiễm khuẩn trong khâu thu nhận $\Rightarrow$ reads không map được vào hệ gen người nhưng map vào hệ gen vi sinh vật.

#### 3. Quy trình xác thực độc lập bằng RT-qPCR
* Dữ liệu RNA-seq là công cụ **sàng lọc diện rộng không giả thuyết (hypothesis-generating tool)** cho toàn bộ ~20.000 gen.
* Sau khi tìm ra danh sách các gen biến thiên hàng đầu (top differentially expressed genes), bắt buộc phải **thực hiện lại phản ứng RT-qPCR** trên một tập mẫu sinh học độc lập khác để xác nhận giá trị biểu hiện trước khi công bố kết luận y sinh.

---

### VII. TỔNG HỢP CÂU HỎI & TRẢ LỜI TRONG LỚP (Q&A SESSION)

#### Câu hỏi 1: Làm sao phân biệt được biểu hiện gen khác biệt là do bệnh lý thực sự hay do lỗi kỹ thuật / biến thiên ngẫu nhiên?
* **Trả lời:**
  * Sử dụng **mẫu lặp sinh học tối thiểu $N \ge 3$**. Các mô hình thống kê vi sai (như Negative Binomial distribution trong DESeq2/edgeR) sẽ ước lượng độ phân tán (dispersion) nội nhóm.
  * Nếu độ biến thiên giữa các mẫu trong cùng 1 nhóm quá lớn (ví dụ mẫu 1 được 100, mẫu 2 nhảy vọt 160), mô hình thống kê sẽ tự động triệt tiêu ý nghĩa ($p\text{-value}$ không đạt, FDR cao), loại bỏ dương tính giả.

#### Câu hỏi 2: Có thể dùng Housekeeping Genes (gen giữ nhà) làm mốc chuẩn hóa tuyệt đối cho RNA-seq không?
* **Trả lời:**
  * **Không nên tin tưởng tuyệt đối vào Housekeeping genes** trong dữ liệu giải trình tự thông lượng lớn.
  * Thực tế khi kiểm tra trên các cơ sở dữ liệu lớn như TCGA, biểu hiện của các gen giữ nhà kinh điển (như *GAPDH*, *ACTB*) vẫn dao động dữ dội giữa các phân nhóm ung thư khác nhau.
  * Trong Bulk RNA-seq, chuẩn hóa được thực hiện trên **toàn bộ phân phối của ma trận đếm** bằng các thuật toán toán học tiên tiến (ví dụ: Median-of-Ratios của DESeq2, Trimmed Mean of M-values - TMM của edgeR).

#### Câu hỏi 3: Làm thế nào để bắt được RNA mong muốn khi chưa biết gen nào sẽ biểu hiện khác biệt?
* **Trả lời:**
  * Phép lọc ở khâu làm thư viện không phải là lọc theo từng gen cụ thể, mà là **lọc theo lớp phân tử (biotype)**.
  * Toàn bộ các mRNA mã hóa protein đều sở hữu cấu trúc đuôi Poly-A ở đầu 3'. Ta sử dụng hạt từ gắn Oligo-dT để giữ lại toàn bộ thế giới mRNA, rửa trôi các loại RNA không mong muốn (chủ yếu là rRNA), sau đó giải trình tự toàn bộ hỗn hợp mRNA này để so sánh.

#### Câu hỏi 4: DNA ti thể (Mitochondrial DNA) có trải qua quá trình tạo Transcript và Isoform không?
* **Trả lời:**
  * **Có.** Hệ gen ti thể (mtDNA) hoạt động tương tự một hệ thống di truyền thu nhỏ.
  * Các gen ti thể vẫn được phiên mã tạo ra mRNA và được dịch mã bởi hệ thống ribosome riêng của ti thể để tổng hợp các tiểu đơn vị protein thuộc chuỗi chuyền điện tử hô hấp tế bào.

---

### VIII. TỔNG KẾT CỐT LÕI & LƯU Ý THỰC HÀNH (KEY TAKEAWAYS)

1. **Bulk RNA-seq đo giá trị trung bình của tập hợp:** Mọi kết luận về biểu hiện gen cần lưu ý đến thành phần các loại tế bào cấu thành khối mô.
2. **Quy tắc thiết kế thí nghiệm:** Luôn ưu tiên mẫu lặp sinh học ($N \ge 3$, khuyến nghị số lẻ $3, 5, 7$) thay vì tăng độ sâu giải trình tự trên một mẫu duy nhất.
3. **Cơ chế định lượng:** RNA-seq định lượng bằng cách đếm số reads căn hàng ($Read\ Counts$). Càng nhiều phân tử mRNA, số reads ánh xạ vào vùng exon của gen càng lớn.
4. **Phân biệt rạch ròi thuật ngữ:**
   * Cắt nối luân phiên trên pre-mRNA $\rightarrow$ Tạo ra các **Transcripts** khác nhau của cùng một gen.
   * Dịch mã các transcripts này $\rightarrow$ Tạo ra các biến thể **Protein Isoforms** tương ứng.
5. **Tiêu chuẩn chất lượng:** Phred score $\ge Q30$ trên 96% reads; dữ liệu giải trình tự diện rộng phải được kiểm chứng lại bằng RT-qPCR độc lập.

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học. Tài liệu phục vụ mục đích học tập và tham khảo.
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.
