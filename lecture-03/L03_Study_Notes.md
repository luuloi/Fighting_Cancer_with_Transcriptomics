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
| **Splice-aware Aligner** | Công cụ căn hàng nhận biết điểm nối exon-intron qua các vị trí cắt nối (STAR, HISAT2) |
| **GTF / GFF3** | Tệp định dạng chuẩn chú giải cấu trúc gen chứa tọa độ exon, CDS, start/stop codon, gene_id, transcript_id |
| **Split Read** | Đoạn đọc ngắn bị tách thành hai hay nhiều đoạn vắt qua intron để căn hàng vào các exon kế cận |
| **Gene Body Coverage** | Đồ thị phân bố độ sâu giải trình tự chuẩn hóa từ đầu 5' đến đầu 3' dọc theo thân gen |
| **3' Bias** | Xu hướng reads tập trung nhiều ở đầu 3' do bắt chọn đuôi poly-A bằng mồi oligo-dT kết hợp phân giải RNA đầu 5' |
| **Feature Counting** | Quy trình đếm số lượng reads căn hàng gối lên các đặc trưng chú giải (gen, transcript, exon) |
| **Raw Count Matrix** | Ma trận đếm thô số reads nguyên vẹn ($Gene \times Sample$) trước khi chuẩn hóa |
| **Relative Abundance** | Độ phong phú tương đối; bản chất RNA-seq là đo lường tương đối phân phối reads, không đo nồng độ tuyệt đối |
| **RPKM / FPKM** | Đơn vị chuẩn hóa chia cho độ dài gen và tổng số reads; không bảo toàn tổng số qua các mẫu (đã lỗi thời) |
| **TPM (Transcripts Per Million)** | Chuẩn hóa theo độ dài gen trước rồi chuẩn hóa theo tổng số reads; tổng TPM mọi mẫu luôn bằng $10^6$ |
| **DESeq2 (Median-of-Ratios)** | Phương pháp chuẩn hóa kích thước thư viện chuyên sâu dựa trên tỷ số trung vị hình học cho phân tích DGE |
| **Pseudo-alignment** | Phương pháp căn hàng giả lập không lập tọa độ chi tiết mà so khớp K-mer trực tiếp lên transcriptome (Salmon, Kallisto) |
| **Downstream Analysis** | Phân tích hạ nguồn sau DGE: làm giàu chức năng (GSEA, GO, KEGG), mạng lưới điều hòa, phân tích sống còn |

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

### VII. QUY TRÌNH TIN SINH HỌC BULK RNA-SEQ: TỪ FASTQ ĐẾN MA TRẬN ĐẾM (PART 3)

```
[FASTQ Thô]
     │
     ▼
[QC & Cắt lọc Trimming] (FastQC / MultiQC, Cutadapt, Trimmomatic: loại adapter & low Q bases)
     │
     ▼
[Căn hàng nhận biết cắt nối (Splice-aware Alignment)] ──> [STAR / HISAT2]
     │                                                      │
     │ (Cần: Reference Genome .fa + GTF Annotation)         │ (Tạo tệp BAM/SAM)
     ▼                                                      ▼
[Đánh giá chất lượng sau Alignment] (MultiQC, RSeQC: Gene body 3' bias, phân bố Exon/Intron/Intergenic)
     │
     ▼
[Đếm đoạn đọc (Feature Counting)] ──> [featureCounts (Subread) / HTSeq-count]
     │
     ▼
[Ma trận đếm thô (Raw Count Matrix)] ───(Số nguyên reads/gene)
     │
     ├────────────────────────────────────────┬────────────────────────────────────────┐
     ▼                                        ▼                                        ▼
[Chuẩn hóa nội bộ / Báo cáo]             [Phân tích DGE Thống kê]                 [Phương pháp thay thế (Fast)]
  - TPM (Khuyến nghị cho relative expr)    - DESeq2 (Median-of-Ratios)              - Pseudo-alignment (Salmon/Kallisto)
  - FPKM/RPKM (Tham khảo tài liệu cũ)      - edgeR (TMM)                            - Định lượng transcript trực tiếp
     │                                        │
     └────────────────────────────────────────┴────────────────────────────────────────┘
                                              │
                                              ▼
                                 [Phân tích Hạ nguồn (Downstream)]
                                   - Functional Enrichment (GO, KEGG, GSEA)
                                   - Regulatory Networks & Survival Analysis
                                   - Biến thể/Đột biến trên RNA (Expressed Variants)
```

---

### VIII. CƠ CHẾ CĂN HÀNG PHÂN TÁCH (SPLICE-AWARE ALIGNMENT) & TỆP CHÚ GIẢI GTF

#### 1. Tại sao DNA aligner thông thường (BWA, Bowtie2) không áp dụng được cho RNA-seq?
* **Bản chất sinh học:** Phân tử mRNA đã trải qua quá trình cắt nối (splicing), toàn bộ các đoạn intron lớn (hàng trăm đến hàng chục nghìn bp) đã bị loại bỏ.
* **Hạn chế của DNA aligner:** Các công cụ căn hàng DNA giả định đoạn đọc liên tục trên hệ gen. Khi một đoạn đọc ngắn (ví dụ 150 bp) vắt ngang qua ranh giới giữa hai exon (Exon Junction), DNA aligner sẽ xem đây là đoạn chèn/mất đoạn (Indel) khổng lồ hoặc không thể căn hàng (Unmapped).
* **Giải pháp: Splice-aware Aligners (STAR, HISAT2):**
  * Nhận biết cơ chế cắt nối, cho phép một read bị chia cắt (**Split Read**) thành hai hay nhiều mảnh căn hàng vào hai exon kế cận cách nhau bởi một khoảng trống intron lớn trên hệ gen tham chiếu.

#### 2. Hai dữ liệu đầu vào bắt buộc khi căn hàng RNA-seq
1. **Reference Genome (FASTA file):** Chuỗi nucleotide tham chiếu của toàn bộ các nhiễm sắc thể (ví dụ: `GRCh38.primary_assembly.genome.fa`).
2. **Transcriptome Annotation (GTF/GFF3 file):** Tệp tọa độ chú giải cấu trúc hệ gen (tải từ GENCODE, Ensembl hoặc NCBI RefSeq; khuyến nghị **GENCODE Comprehensive**).

> [!IMPORTANT]
> Nếu chỉ cung cấp FASTA mà không có tệp GTF, phần mềm không thể xác định chính xác ranh giới exon-intron, không tính toán được tọa độ thân gen (Gene body), và hoàn toàn không thể thực hiện bước đếm đoạn đọc (Feature Counting) về sau!

#### 3. Cấu trúc chuẩn 9 cột của tệp chú giải GTF (Gene Transfer Format)

| Cột | Tên trường | Ví dụ | Ý nghĩa sinh học |
| :--- | :--- | :--- | :--- |
| **1** | `seqname` | `chr1` | Tên nhiễm sắc thể hoặc contig |
| **2** | `source` | `HAVANA` / `ENSEMBL` | Cơ sở dữ liệu hoặc chương trình chú giải |
| **3** | `feature` | `gene`, `transcript`, `exon`, `CDS`, `start_codon` | Loại đặc trưng sinh học |
| **4** | `start` | `1030799` | Tọa độ bắt đầu (1-based, inclusive) |
| **5** | `end` | `1031980` | Tọa độ kết thúc (1-based, inclusive) |
| **6** | `score` | `.` | Điểm tin cậy (thường để dấu chấm `.`) |
| **7** | `strand` | `+` hoặc `-` | Sợi khuôn (sợi dương hoặc sợi âm) |
| **8** | `frame` | `0`, `1`, `2`, hoặc `.` | Khung dịch mã đọc codon |
| **9** | `attribute` | `gene_id "ENSG..."; transcript_id "ENST...";` | Thuộc tính định danh dạng cặp khóa-giá trị |

---

### IX. ĐẶC TRƯNG PHÂN BỐ READS & HIỆN TƯỢNG THIÊN LỆCH ĐẦU 3' (3' BIAS)

#### 1. Đồ thị bao phủ thân gen (Gene Body Coverage Profile)
* Khi vẽ đồ thị phân bố độ sâu reads từ đầu 5' (0%) đến đầu 3' (100%) của tất cả các gen, người ta quan sát thấy **độ sâu reads ở đầu 3' cao hơn đáng kể so với đầu 5'**.
* **Nguyên nhân sinh học và kỹ thuật (3' Bias):**
  1. **Poly-A Enrichment:** Thư viện bắt giữ mRNA bằng hạt từ gắn chuỗi oligo-dT lai với đuôi Poly-A ở đầu 3'.
  2. **Độ nguyên vẹn của RNA:** Các enzyme RNase nội sinh thường gặm nhấm và thoái hóa RNA từ đầu 5' trước. Đầu 3' được bảo vệ bởi đuôi poly-A và mồi poly-dT, do đó xác suất thu hồi và phiên mã ngược cDNA thành công ở vùng 3' cao hơn nhiều.
* **Ngưỡng kiểm soát chất lượng (QC benchmark):**
  * Độ chênh lệch chấp nhận được trong điều kiện thư viện chuẩn là khoảng **20% – 25%**.
  * Nếu đầu 5' sụt giảm quá nghiêm trọng (>50%), mẫu RNA đã bị thoái hóa nặng trong khâu trích xuất, cần đánh giá lại RIN score và tối ưu hóa wet-lab.

#### 2. Tỷ lệ phân bố Reads trên các vùng hệ gen (Genomic Context Distribution)

| Vùng phân bố | Tỷ lệ mong đợi | Ý nghĩa kiểm soát chất lượng |
| :--- | :--- | :--- |
| **Exonic Regions** | **$\ge 80\% - 90\%$** | Chuẩn đẹp của thư viện Poly-A mRNA. Nếu $<80\%$, thư viện có vấn đề kỹ thuật. |
| **Intronic Regions** | **$\le 10\%$** | Phản ánh pre-mRNA chưa hoàn tất cắt nối hoặc hiện tượng giữ lại intron (intron retention). |
| **Intergenic Regions** | **$\le 1\% - 2\%$** | Reads rơi vào vùng gian gen; nếu tăng cao bất thường là dấu hiệu nhiễm DNA bộ gen (gDNA contamination). |
| **Ribosomal RNA (rRNA)** | **$\le 5\% - 10\%$** | Đánh giá hiệu quả loại bỏ rRNA. Mặc dù tế bào chứa $>90\%$ rRNA, sau khi bắt poly-A/Ribo-Zero, tỷ lệ này bắt buộc phải giảm xuống $<10\%$ (lý tưởng $<5\%$). |

> [!TIP]
> Nếu tỷ lệ rRNA tồn dư vẫn cao (15%–20%) nhưng mẫu lâm sàng không thể làm lại, giải pháp tin sinh học khả dĩ là **tăng độ sâu giải trình tự** (ví dụ từ 20M reads lên 30M–40M reads) để bù trừ lượng reads bị tiêu hao vào rRNA, đảm bảo các gen biểu hiện thấp vẫn có đủ độ sâu phân tích.

---

### X. NGUYÊN LÝ ĐẾM ĐOẠN ĐỌC (FEATURE COUNTING) VỚI FEATURECOUNTS

Sau khi có tệp căn hàng BAM, công cụ `featureCounts` (thuộc bộ Subread) hoặc `HTSeq-count` được sử dụng để tổng hợp số lượng reads ánh xạ vào từng gen/transcript.

#### 1. Quy tắc tính Overlap mặc định và Tùy chỉnh
* **Quy tắc mặc định:** Chỉ cần read gối lên đặc trưng (exon/gene) **tối thiểu 1 base pair (1 bp overlap)** là được tính điểm cộng dồn cho đặc trưng đó.
* **Tùy biến độ khắt khe:** Người phân tích có thể nâng ngưỡng overlap lên $10$ bp hoặc $20$ bp để tăng độ tin cậy, nhưng **bắt buộc phải ghi rõ tham số này trong phần Methods của công trình khoa học** để đảm bảo tính tái lập.

#### 2. Xử lý các tình huống căn hàng đặc biệt

| Tình huống căn hàng | Cơ chế xử lý trong FeatureCounts | Minh họa / Hệ quả |
| :--- | :--- | :--- |
| **Read nằm trọn trong Exon** | Tính 1 count cho gen tương ứng. | Trường hợp tiêu chuẩn lý tưởng. |
| **Split Read qua ranh giới Exon-Exon** | Tính 1 count cho gen tương ứng. | STAR căn hàng 2 phần read vào 2 exon kế cận; featureCounts nhận diện thuộc cùng 1 gen. |
| **Paired-End Reads (Cặp đọc PE)** | Đếm theo đơn vị **Fragment** (1 cặp đọc = 1 fragment count). | Tránh hiện tượng đếm nhân đôi khi cả Read 1 và Read 2 cùng map vào một exon. |
| **Intron Retention** | Phụ thuộc vào chú giải GTF. | Nếu transcript chú giải chứa intron đó $\rightarrow$ tính count; nếu chỉ đếm trên exon chuẩn $\rightarrow$ bị bỏ qua. |
| **Read gối lên 2 gen chồng lấn (Overlapping Genes)** | Mặc định **bị loại bỏ (Ambiguous)**, không tính cho gen nào cả. | Trừ khi sử dụng cờ giải trình tự định hướng sợi (`-s 1` hoặc `-s 2`) để phân định sợi mang gen. |
| **Multi-mapping Reads** | Mặc định bỏ qua; có thể dùng tùy chọn `-M` để phân bổ theo trọng số. | Khuyến nghị chỉ giữ lại uniquely mapped reads để đảm bảo độ chính xác thống kê. |

#### 3. Nhóm mức độ đếm (Grouping Level)
* `-t exon -g gene_id`: Đếm theo cấp độ gen (**Gene-level counting**) $\rightarrow$ Tổng hợp toàn bộ reads của tất cả exon thuộc cùng một `gene_id`.
* `-t exon -g transcript_id`: Đếm theo cấp độ transcript (**Transcript-level counting**) $\rightarrow$ Phân tách riêng biệt từng biến thể cắt nối.

---

### XI. CHUẨN HÓA DỮ LIỆU ĐẾM (NORMALIZATION): RAW COUNT, RPKM/FPKM, TPM & DESEQ2

#### 1. Tại sao KHÔNG ĐƯỢC so sánh trực tiếp Raw Counts?
Điểm đếm thô (Raw Count) bị chi phối bởi 4 yếu tố gây sai lệch kỹ thuật (Biases):
1. **Độ sâu giải trình tự (Sequencing Depth / Library Size):** Mẫu A giải 40M reads sẽ ghi nhận số count ở hầu hết các gen cao gấp đôi mẫu B chỉ giải 20M reads, dù nồng độ sinh học thực tế là tương đương.
2. **Chiều dài gen (Gene Length):** Gen càng dài (ví dụ *BRCA1/2* có 23–26 exon) sẽ tạo ra càng nhiều mảnh cDNA $\rightarrow$ nhận được số reads lớn hơn gấp nhiều lần so với gen ngắn chỉ có 1 exon (ví dụ *SOX2*).
3. **Thành phần %GC (GC Content):** Các vùng DNA có %GC quá cao ($>70\%$) hoặc quá thấp ($<30\%$) bị khuếch đại kém hơn trong chu kỳ PCR của thư viện.
4. **Thành phần RNA (RNA Composition):** Nếu một vài gen biểu hiện cực mạnh trong mẫu A (chiếm tới 50% reads), toàn bộ các gen còn lại sẽ bị sụt giảm số reads giả tạo so với mẫu B.

#### 2. Bản chất đo lường: Độ phong phú tương đối (Relative Abundance)
> [!IMPORTANT]
> **Định đề cốt lõi:** RNA-seq **KHÔNG ĐO LƯỜNG NỒNG ĐỘ TUYỆT ĐỐI**. RNA-seq chỉ đo lường **độ phong phú tương đối (Relative Abundance)** của các phân tử transcript trong tổng dung lượng thư viện giải trình tự của từng mẫu.
> Do đó, tuyệt đối không lấy giá trị đếm thô của một mẫu trong nghiên cứu này so sánh đối đầu với mẫu của phòng thí nghiệm khác nếu không được xử lý đồng nhất qua cùng một pipeline chuẩn hóa.

#### 3. Bảng so sánh toàn diện các đơn vị chuẩn hóa

| Đơn vị | Cơ chế tính toán | Chuẩn hóa Độ dài? | Chuẩn hóa Độ sâu? | Tổng mẫu (Sum per sample) | Ứng dụng phù hợp |
| :--- | :--- | :---: | :---: | :--- | :--- |
| **Raw Count** | Số reads nguyên thủy đếm được. | ❌ Không | ❌ Không | Dao động tự do theo độ sâu thư viện. | **Bắt buộc cho DESeq2 / edgeR** (các mô hình Negative Binomial đòi hỏi số nguyên). |
| **RPKM / FPKM** | $\frac{\text{Counts}}{\text{Gene Length (kb)} \times \text{Library Size (M)}}$ | ✅ Có | ✅ Có | **Khác nhau giữa các mẫu** $\rightarrow$ Gây sai lệch khi so sánh liên mẫu! | Lỗi thời; chỉ dùng đối chiếu các bài báo cũ giai đoạn 2008–2012. |
| **TPM** | 1. $\text{RPK} = \frac{\text{Count}}{\text{Length (kb)}}$<br>2. $\text{TPM} = \frac{\text{RPK}}{\sum \text{RPK}} \times 10^6$ | ✅ Có | ✅ Có | **Luôn bằng $1.000.000$ ở mọi mẫu** $\rightarrow$ So sánh tương đối rất chuẩn xác. | Khảo sát trực quan mức biểu hiện, so sánh tỷ lệ gen trong mẫu và giữa các mẫu. |
| **DESeq2 (Median of Ratios)** | Chia count cho hệ số kích thước (Size Factor) tính từ tỷ số trung vị hình học qua các mẫu. | ❌ Không (không cần vì chiều dài gen cố định giữa các nhóm) | ✅ Có (khử cả sequencing depth & composition bias) | Biến thiên theo phân phối chuẩn hóa thống kê. | **Phân tích biểu hiện sai khác (DGE)**; kiểm định giả thuyết thống kê có kiểm soát FDR. |

---

### XII. SO SÁNH TRADITIONAL ALIGNMENT (STAR) VÀ PSEUDO-ALIGNMENT (SALMON/KALLISTO)

Trong thực tế tin sinh học, có hai trường phái lớn để xử lý dữ liệu RNA-seq từ FASTQ thành bảng đếm:

```
[Trường phái 1: Traditional Alignment]
FASTQ ───> [STAR / HISAT2] ───> [BAM Coordinates] ───> [featureCounts] ───> [Raw Count Matrix (Integer)]

[Trường phái 2: Pseudo-alignment / Lightweight]
FASTQ ───> [Salmon / Kallisto] (So khớp K-mer trực tiếp lên Transcriptome Index) ───> [Estimated Counts (Float / Decimals)]
```

| Tiêu chí | Traditional Alignment (STAR + featureCounts) | Pseudo-alignment (Salmon / Kallisto) |
| :--- | :--- | :--- |
| **Nguyên lý hoạt động** | Căn hàng từng nucleotide của read lên hệ gen tham chiếu, tìm vị trí splice junction chính xác. | Không căn hàng từng base; đối chiếu tập hợp các **K-mers** của read với biểu đồ De Bruijn của hệ phiên mã (cDNA). |
| **Tệp dữ liệu tham chiếu** | Reference Genome FASTA + GTF Annotation. | Chỉ cần Transcriptome FASTA (các chuỗi cDNA thành phẩm). |
| **Tệp đầu ra trung gian** | Tệp nhị phân **BAM/SAM** rất lớn (4 GB – 10 GB/mẫu), lưu trữ tọa độ từng nucleotide. | Không tạo tệp BAM; xuất thẳng bảng định lượng transcript thô (`quant.sf` / `abundance.tsv`). |
| **Bản chất số đếm** | Số nguyên thuần túy (**Integers**, ví dụ: 45, 120 reads). | Số thực ước lượng (**Estimated fractional counts**, ví dụ: 40.5 reads) do thuật toán Expectation-Maximization (EM). |
| **Tốc độ & Tài nguyên** | Chạy lâu hơn, đòi hỏi RAM lớn (**$\ge 32$ GB RAM** cho STAR index hệ gen người). | **Cực nhanh** (vài phút/mẫu), tiêu tốn rất ít RAM (khoảng 4–8 GB). |
| **Khả năng phát hiện mới** | **Rất cao:** Phát hiện novel splice junctions, fusion genes, biến thể cấu trúc, giữ lại intron. | Hạn chế: Chỉ định lượng được các transcript đã có sẵn trong cơ sở dữ liệu tham chiếu. |
| **Khuyến nghị sử dụng** | **Tiêu chuẩn vàng cho nghiên cứu cơ bản & lâm sàng**, đặc biệt khi cần kiểm tra tọa độ trực quan trên IGV. | Phù hợp khi tài nguyên máy tính hạn chế, cần sàng lọc nhanh số lượng lớn mẫu (hàng trăm/nghìn mẫu). |

---

### XIII. PHÂN TÍCH BIỂU HIỆN SAI KHÁC GENE-LEVEL VS TRANSCRIPT-LEVEL & HƯỚNG ĐI HẠ NGUỒN

#### 1. Tại sao phân tích cấp độ Transcript quan trọng trong Ung thư? Ví dụ gen *GRIA*
* **Gen *GRIA* (Glutamate Ionotropic Receptor AMPA Type Subunit):**
  * Chứa hai exon thay thế là **Exon 9α** và **Exon 9β**.
  * Quá trình cắt nối luân phiên tạo ra hai biến thể: Isoform chứa 9α và Isoform chứa 9β.
* **Hạn chế của Gene-level analysis:**
  * Nếu một loại mô ung thư chuyển dịch biểu hiện từ isoform 9α sang isoform 9β, tổng số reads ánh xạ vào gen *GRIA* có thể **hoàn toàn không thay đổi**.
  * Nếu chỉ phân tích ở cấp độ gen (Gene-level), phần mềm kết luận gen *GRIA* không có biểu hiện sai khác ($p > 0.05$).
  * Nhưng ở cấp độ sinh học, hai protein isoform 9α và 9β lại có hoạt tính sinh học hoàn toàn trái ngược nhau!
* **Kết luận:** Khi nghiên cứu cơ chế bệnh sinh phân tử sâu sắc, phân tích biểu hiện vi sai cấp độ transcript (**Differential Transcript Usage - DTU** hoặc **Differential Splicing**) đem lại độ nhạy sinh học vượt trội.

#### 2. Lộ trình phân tích toàn diện: Upstream vs Downstream Analysis
* **Phân tích cơ bản (Upstream / Basic Analysis):**
  * Từ tệp FASTQ thô $\rightarrow$ Alignment (BAM) $\rightarrow$ Đếm reads (Counts) $\rightarrow$ Chuẩn hóa $\rightarrow$ Danh sách các gen biểu hiện sai khác (DEGs: tăng hoặc giảm biểu hiện giữa nhóm Ung thư vs Bình thường).
* **Phân tích chuyên sâu hạ nguồn (Downstream / Advanced Analysis):**
  1. **Phân tích làm giàu lộ trình sinh học (Pathway / Functional Enrichment):**
     * Tìm hiểu các DEGs tác động vào chu trình tế bào nào (Gene Ontology - GO, KEGG Pathways, Reactome).
     * Phân tích làm giàu bộ gen **GSEA (Gene Set Enrichment Analysis)** không phụ thuộc vào ngưỡng cắt $p$-value tùy tiện.
  2. **Mạng lưới điều hòa gen (Gene Regulatory Networks):**
     * Khảo sát tương tác protein-protein (PPI qua STRING), xác định các gen trung tâm (Hub genes, Master Transcription Factors).
  3. **Phân tích tiên lượng sống còn (Clinical Survival Analysis):**
     * Đối chiếu mức độ biểu hiện của bộ gen chỉ dấu với thời gian sống thêm toàn bộ (Overall Survival - OS, DFS) trên tập dữ liệu lâm sàng TCGA.
  4. **Phát hiện đột biến trên phân tử RNA (Expressed Variant Calling):**
     * Tận dụng dữ liệu RNA-seq để phát hiện đột biến sinh dưỡng (somatic mutations) trực tiếp trên các transcript biểu hiện hoạt động.

---

### XIV. TỔNG HỢP CÂU HỎI & TRẢ LỜI TRONG LỚP (Q&A SESSION)

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

#### Câu hỏi 5: Tại sao trong bảng đếm của Pseudo-alignment (Salmon/Kallisto) lại xuất hiện số thập phân (như 40.5 reads)?
* **Trả lời:**
  * Pseudo-alignment không căn hàng từng nucleotide vào một tọa độ duy nhất. Khi một read mang các K-mer xuất hiện ở nhiều transcript khác nhau của cùng một gen (chia sẻ chung các exon tương đồng), phần mềm không thể gán độc quyền read đó cho transcript nào.
  * Thuật toán **Expectation-Maximization (EM)** sẽ phân bổ xác suất và ước lượng tỷ lệ đóng góp của read đó cho từng transcript dựa trên độ dài và tần suất xuất hiện tổng thể. Giá trị ước lượng này mang bản chất kỳ vọng toán học nên là **số thực (số thập phân)** thay vì số nguyên đếm trực tiếp.

#### Câu hỏi 6: Tại sao TPM lại vượt trội hơn RPKM/FPKM khi so sánh giữa các mẫu thí nghiệm?
* **Trả lời:**
  * Trong công thức RPKM/FPKM, phép chuẩn hóa chia cho độ sâu thư viện trước rồi mới chia cho chiều dài gen. Do phân phối chiều dài các gen khác nhau giữa các mẫu, tổng giá trị RPKM/FPKM sau khi cộng lại **không bằng nhau giữa các mẫu**.
  * Trong TPM, bước chia cho chiều dài gen được thực hiện trước để đưa về tỷ lệ phân tử (Rate of transcription), sau đó mới chuẩn hóa tổng. Do đó, **tổng TPM của mọi mẫu luôn luôn bằng đúng $1.000.000$**. Một gen có giá trị $10$ TPM ở mẫu 1 và $10$ TPM ở mẫu 2 đồng nghĩa với việc gen đó chiếm chính xác tỷ lệ $10$ phân tử trên mỗi $1.000.000$ phân tử transcript trong cả hai mẫu, đảm bảo tính so sánh tương đối trực tiếp.

#### Câu hỏi 7: Khi nào nên sử dụng phần mềm STAR truyền thống, khi nào nên dùng Salmon/Kallisto?
* **Trả lời:**
  * **Chọn STAR + featureCounts:** Khi bạn thực hiện đề tài nghiên cứu ung thư chuẩn mực, cần kiểm tra trực quan các điểm nối exon bất thường (novel splice junctions), biến thể dung hợp gen (fusion genes), khảo sát đột biến trên IGV, hoặc quy chuẩn xuất bản bài báo khoa học.
  * **Chọn Salmon / Kallisto:** Khi cần rà soát nhanh dữ liệu lớn (hàng trăm mẫu từ SRA/TCGA), máy tính cá nhân bị giới hạn bộ nhớ RAM ($<16$ GB), hoặc khi mục tiêu phân tích tập trung chủ yếu vào định lượng biến thể transcript (Transcript-level isoform switching) đã được chú giải hoàn chỉnh.

---

### XV. TỔNG KẾT CỐT LÕI & QUY TẮC THỰC HÀNH (KEY TAKEAWAYS)

#### 1. Nền tảng Sinh học & Thiết kế thí nghiệm (Wet-lab & Experimental Design)
1. **Bulk RNA-seq đo giá trị trung bình của tập hợp:** Mọi kết luận về biểu hiện gen cần lưu ý đến thành phần các loại tế bào cấu thành khối mô (Tissue Heterogeneity).
2. **Quy tắc thiết kế thí nghiệm:** Luôn ưu tiên mẫu lặp sinh học ($N \ge 3$, khuyến nghị số lẻ $3, 5, 7$) thay vì tăng độ sâu giải trình tự trên một mẫu duy nhất.
3. **Cơ chế định lượng:** RNA-seq định lượng bằng cách đếm số reads căn hàng ($Read\ Counts$). Càng nhiều phân tử mRNA, số reads ánh xạ vào vùng exon của gen càng lớn.
4. **Phân biệt rạch ròi thuật ngữ:**
   * Cắt nối luân phiên trên pre-mRNA $\rightarrow$ Tạo ra các **Transcripts** khác nhau của cùng một gen.
   * Dịch mã các transcripts này $\rightarrow$ Tạo ra các biến thể **Protein Isoforms** tương ứng.
5. **Tiêu chuẩn chất lượng:** Phred score $\ge Q30$ trên 96% reads; dữ liệu giải trình tự diện rộng phải được kiểm chứng lại bằng RT-qPCR độc lập.

#### 2. Quy trình Xử lý Dữ liệu & Tin sinh học (Bioinformatics & Data Processing)
6. **Splice-aware Alignment là bắt buộc:** Căn hàng RNA-seq phải dùng công cụ nhận biết cắt nối (STAR/HISAT2) kết hợp bắt buộc cả tệp FASTA hệ gen và tệp chú giải GTF.
7. **Kiểm soát thiên lệch đầu 3':** Hiện tượng 3' bias là đặc trưng kỹ thuật bình thường do bắt mồi Oligo-dT và poly-A tail; tỷ lệ reads rơi vào exon phải đạt $\ge 80\%$, intronic $<10\%$, và rRNA tồn dư $<10\%$.
8. **Quy tắc đếm FeatureCounts:** Phân biệt rõ giữa đếm cấp độ gen (`-g gene_id`) và cấp độ transcript (`-g transcript_id`); reads vắt ngang qua 2 gen khác nhau sẽ bị loại bỏ để tránh dương tính giả.
9. **Chuẩn hóa là chìa khóa:**
   * Dùng **Raw Counts** cho các kiểm định mô hình thống kê DGE (DESeq2, edgeR).
   * Dùng **TPM** cho khảo sát trực quan và so sánh độ phong phú tương đối giữa các mẫu.
   * **Tuyệt đối không dùng RPKM/FPKM** cho các nghiên cứu mới.
10. **Hiểu bản chất Relative Abundance:** RNA-seq chỉ đo độ phong phú tương đối trong thư viện; việc so sánh đòi hỏi điều kiện chuẩn bị thư viện đồng nhất và kích thước mẫu đủ tin cậy.

---

> [!NOTE]
> **Disclaimer:** Tài liệu học tập này được tổng hợp và biên soạn bởi Antigravity dựa trên nội dung transcript của khóa học. Tài liệu phục vụ mục đích học tập và tham khảo.
> Nếu còn thiếu xót, xin anh/chị vui lòng **comment** tại tab **[Issue](https://github.com/luuloi/Fighting_Cancer_with_Transcriptomics/issues)** trong Github. Xin chân thành cảm ơn.
