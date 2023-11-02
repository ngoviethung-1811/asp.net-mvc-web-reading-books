create database WEBDOCSACH;
use WEBDOCSACH;

create table NHANVIEN (
	maNV varchar(5) primary key,
	tenNV nvarchar(50) not null,
	avatar nvarchar(max),
	email varchar(50) not null,
	matKhau varchar(50) not null,
	isAdmin BIT not null,
);

create table KHACHHANG(
	maKH varchar(6) primary key,
	tenKH nvarchar(50) not null,
	avatar nvarchar(max),
	email varchar(50) not null,
	matKhau varchar(50) not null,
	isVIP BIT not null,
);
create table SACH(
	maSach varchar(5) primary key,
	maTheLoai varchar(5) foreign key references THELOAI(maTheLoai),
	tenSach nvarchar(50) not null,
	anhBia nvarchar(max),
	tacgia nvarchar (50) not null,
	loai int not null,
	gia money not null,
	namXuatBan int not null,
	moTa nvarchar(max) not null 
)
create table NOIDUNGSACH (
	maSach varchar(5) foreign key references SACH(maSach) ,
	maChuong varchar(5),
	tenChuong nvarchar(50),
	noiDung nvarchar(max) not null,
	primary key (maSach, maChuong)
)

create table GIAODICH_MUAVIP(
	maKH varchar(6) foreign key references KHACHHANG(maKH) ,
	thoiGian date not null ,
	giaVIP money not null,
	primary key (maKH, thoiGian)
)
create table GIAODICH_MUASACH(
	maKH varchar(6) foreign key references KHACHHANG(maKH) ,
	maSach varchar(5) foreign key references SACH(maSach),
	gia money not null,
	thoiGian date not null,
	primary key (maKH,maSach)
)

create table THELOAI (
	maTheLoai varchar(5) primary key,
	tenTheLoai nvarchar(50) not null
)

create table THAMSO(
	maTS varchar(5) primary key,
	tenTS nvarchar(50) not null,
	dvt nvarchar(30) not null,
	giaTri int not null,
	tinhTrang bit not null
)

create table SACH_LUOTXEM(
	maSach varchar(5) primary key foreign key references SACH(maSach),
	soLuotXem bigint not null,
)

CREATE PROCEDURE NhanVien_TimKiem
    @maNV varchar(5)=NULL,
	@tenNV nvarchar(50)=NULL,
	@email varchar(50)= NULL,
	@isAdmin nvarchar(3)= NULL
AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM NHANVIEN
       WHERE  (1=1)
       '
IF @maNV IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (maNV LIKE ''%'+@maNV+'%'')
              '
IF @tenNV IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
			  AND (tenNV LIKE N''%'+@tenNV+'%'')
	   '
IF @email IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (email LIKE ''%'+@email+'%'')
              '
IF @isAdmin IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (isAdmin LIKE ''%'+@isAdmin+'%'')
                  '
	EXEC SP_EXECUTESQL @SqlStr
END

CREATE PROCEDURE KhachHang_TimKiem
    @maKH varchar(5)=NULL,
	@tenKH nvarchar(50)=NULL,
	@email varchar(50)= NULL,
	@isVIP nvarchar(3)= NULL
AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM KHACHHANG
       WHERE  (1=1)
       '
IF @maKH IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (maKH LIKE ''%'+@maKH+'%'')
              '
IF @tenKH IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
			  AND (tenKH LIKE N''%'+@tenKH+'%'')
	   '
IF @email IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (email LIKE ''%'+@email+'%'')
              '
IF @isVIP IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (isVIP LIKE ''%'+@isVIP+'%'')
                  '
	EXEC SP_EXECUTESQL @SqlStr
END

CREATE PROCEDURE Sach_TimKiem
    @maSach varchar(5)=NULL,
	@tenSach nvarchar(50)=NULL,
	@tacgia nvarchar(50)= NULL,
	@loai varchar(3) =NULL,
	@giaMin varchar(30)=NULL,
	@giaMax varchar(30)=NULL,
	@namXuatBan varchar(5) =null,
	@maTheLoai varchar(5) =null
AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM SACH
       WHERE  (1=1)
       '
IF @maSach IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (maSach LIKE ''%'+@maSach+'%'')
              '
IF @tenSach IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
			  AND (tenSach LIKE N''%'+@tenSach+'%'')
	   '
IF @tacgia IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (tacgia LIKE N''%'+@tacgia+'%'')
              '
IF @loai IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (loai LIKE ''%'+@loai+'%'')
			 '
IF @giaMin IS NOT NULL and @giaMax IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (gia Between Convert(money,'''+@giaMin+''') AND Convert(money, '''+@giaMax+'''))
			 '
IF @namXuatBan IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (namXuatBan LIKE ''%'+@namXuatBan+'%'')
			 '
IF @maTheLoai IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (maTheLoai LIKE ''%'+@maTheLoai+'%'')
              '
	EXEC SP_EXECUTESQL @SqlStr
END

CREATE PROCEDURE Chuong_TimKiem
    @maSach varchar(5)=NULL,
	@maChuong varchar(5)=NUll,
	@tenChuong nvarchar(50)=NULL
AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM NOIDUNGSACH
       WHERE  (1=1)
       '
IF @maSach IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (maSach LIKE ''%'+@maSach+'%'')
              '
IF @maChuong IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (maChuong LIKE ''%'+@maChuong+'%'')
              '
IF @tenChuong IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
			  AND (tenChuong LIKE N''%'+@tenChuong+'%'')
	   '
	EXEC SP_EXECUTESQL @SqlStr
END

CREATE PROCEDURE TimGDVTheoThang
    @month1 INT,
    @year1 INT,
    @month2 INT,
    @year2 INT
AS
BEGIN
    SET NOCOUNT ON;

	IF @month1 IS NULL
    BEGIN
        SET @month1 = 1
    END

    IF @year1 IS NULL
    BEGIN
        SET @year1 = YEAR(GETDATE())
    END

    IF @month2 IS NULL
    BEGIN
        SET @month2 = 1
    END

    IF @year2 IS NULL
    BEGIN
        SET @year2 = YEAR(GETDATE())
    END

    DECLARE @fromDate DATETIME, @toDate DATETIME;
    SET @fromDate = CAST(FORMAT(@year1 * 10000 + @month1 * 100 + 1, '0000-00-00') AS DATETIME);
    SET @toDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, CAST(FORMAT(@year2 * 10000 + @month2 * 100 + 1, '0000-00-00') AS DATETIME)));

    SELECT gv.*
    FROM KHACHHANG kh INNER JOIN GIAODICH_MUAVIP gv on kh.maKH=gv.maKH 
    WHERE gv.thoiGian >= @fromDate AND gv.thoiGian <= @toDate
END
go
CREATE PROCEDURE TimGDSTheoThang
    @month1 INT,
    @year1 INT,
    @month2 INT,
    @year2 INT
AS
BEGIN
    SET NOCOUNT ON;

	IF @month1 IS NULL
    BEGIN
        SET @month1 = 1
    END

    IF @year1 IS NULL
    BEGIN
        SET @year1 = YEAR(GETDATE())
    END

    IF @month2 IS NULL
    BEGIN
        SET @month2 = 1
    END

    IF @year2 IS NULL
    BEGIN
        SET @year2 = YEAR(GETDATE())
    END

    DECLARE @fromDate DATETIME, @toDate DATETIME;
    SET @fromDate = CAST(FORMAT(@year1 * 10000 + @month1 * 100 + 1, '0000-00-00') AS DATETIME);
    SET @toDate = DATEADD(DAY, -1, DATEADD(MONTH, 1, CAST(FORMAT(@year2 * 10000 + @month2 * 100 + 1, '0000-00-00') AS DATETIME)));

    SELECT gs.*
    FROM KHACHHANG kh INNER JOIN GIAODICH_MUASACH gs on kh.maKH=gs.maKH INNER JOIN  SACH s on s.maSach =gs.maSach
    WHERE  gs.thoiGian >= @fromDate AND gs.thoiGian  <= @toDate 
END

CREATE PROCEDURE Sach_TimKiemTL
	@maTheLoai varchar(5) =null
AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM SACH
       WHERE  (1=1)
       '
IF @maTheLoai IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
              AND (maTheLoai LIKE ''%'+@maTheLoai+'%'')
              '
	EXEC SP_EXECUTESQL @SqlStr
END

CREATE PROCEDURE Sach_TimKiemTSTG
    @tenTK nvarchar(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SqlStr nvarchar(4000);
    
    SET @SqlStr = N'SELECT * FROM SACH WHERE 1=1';
    
    IF @tenTK IS NOT NULL
    BEGIN
        SET @SqlStr = @SqlStr + N' AND (tenSach LIKE N''%' + @tenTK + N'%'' OR tacgia LIKE N''%' + @tenTK + N'%'')';
    END

    EXEC sp_executesql @SqlStr;
END

CREATE PROCEDURE Sach_TimKiemLoai
	@loai varchar(3) =NULL
AS
BEGIN
DECLARE @SqlStr NVARCHAR(4000),
		@ParamList nvarchar(2000)
SELECT @SqlStr = '
       SELECT * 
       FROM SACH
       WHERE  (1=1)
       '
IF @loai IS NOT NULL
       SELECT @SqlStr = @SqlStr + '
             AND (loai LIKE ''%'+@loai+'%'')
			 '
	EXEC SP_EXECUTESQL @SqlStr
END

insert into THAMSO values 
	('TS001', N'Giá VIP', 'NVD', 200000, 1);

insert into NHANVIEN values 
	('NV001', N'Nguyễn Văn Trãi', 'employee.png', 'trainv@gmail.com', '202cb962ac59075b964b07152d234b70', 1),
	('NV002', N'Trần Thị Bé Ba', 'employee.png', 'batbt@gmail.com', '202cb962ac59075b964b07152d234b70', 0),
	('NV003', N'Đỗ Văn Đồng', 'employee.png', 'dongdv@gmail.com', '202cb962ac59075b964b07152d234b70', 0),
	('NV004', N'Nguyễn Hải Tuấn', 'employee.png', 'tuannh@gmail.com', '202cb962ac59075b964b07152d234b70', 1),
	('NV005', N'Trần Thị Thanh Vân', 'employee.png', 'vanttv@gmail.com', '202cb962ac59075b964b07152d234b70', 0),
	('NV006', N'Ngô Việt Hưng', 'employee.png', 'hung.nv.62cntt@ntu.edu.vn', '202cb962ac59075b964b07152d234b70', 1);

insert into KHACHHANG values 
		('KH0001', N'Nguyễn Ba Đồng', 'customer.png', 'dongnb@gmail.com', '202cb962ac59075b964b07152d234b70', 1),
		('KH0002', N'Trần Phương Dung', 'customer.png', 'dungtp@gmail.com', '202cb962ac59075b964b07152d234b70', 0),
		('KH0003', N'Phan Thị Duyên', 'customer.png', 'duyenpt@gmail.com', '202cb962ac59075b964b07152d234b70', 0),
		('KH0004', N'Ngô Nhã Phương thanh', 'customer.png', 'thanhnnp@gmail.com', '202cb962ac59075b964b07152d234b70', 0),
		('KH0005', N'Trần Bình Ba', 'customer.png', 'batb@gmail.com', '202cb962ac59075b964b07152d234b70', 0),
		('KH0006', N'Nguyễn Ba Bảo', 'customer.png', 'baonb@gmail.com', '202cb962ac59075b964b07152d234b70', 1),
		('KH0007', N'Trần Phương Thúy', 'customer.png', 'thuytp@gmail.com', '202cb962ac59075b964b07152d234b70', 1),
		('KH0008', N'Phan Thị Phương', 'customer.png', 'phuongpt@gmail.com', '202cb962ac59075b964b07152d234b70', 1),
		('KH0009', N'Ngô Nhã Phong', 'customer.png', 'phongnn@gmail.com', '202cb962ac59075b964b07152d234b70', 1),
		('KH0010', N'Trần Đình Thiên', 'customer.png', 'thientd@gmail.com', '202cb962ac59075b964b07152d234b70', 0)

insert into GIAODICH_MUAVIP values
		('KH0001', CAST(N'2022-1-19' AS Date),180000),
		('KH0006', CAST(N'2022-3-22' AS Date),180000),
		('KH0007', CAST(N'2023-3-19' AS Date),200000),
		('KH0008', CAST(N'2023-5-1' AS Date),200000),
		('KH0009', CAST(N'2023-5-3' AS Date),200000)

insert into THELOAI values
	('TL001', N'Cổ tích - Thần thoại'),
	('TL002', N'Trinh Thám - Hình Sự'),
	('TL003', N'Tâm lý - Kỹ Năng sống'),
	('TL004', N'Triết học'),
	('TL005', N'Truyện ma - Truyện kinh dị'),
	('TL006', N'Lịch sử - Chính trị'),
	('TL007', N'Thể thao - Nghệ thuật'),
	('TL007', N'Văn học Việt Nam')

insert into SACH values
	('MS001', 'TL001', N'Thần Thoại Hy Lạp','TTHL.jpg',N'Nguyễn Văn Khoả',0,0,2006,N'Từ bao đời nay, thần thoại Hy Lạp đã trở thành một giá trị vô cùng quý báu của 
	gia tài văn hóa nhân loại. Những nhân vật, điển tích trong đây liên tục được tái sinh, hiện diện, truyền nguồn cảm hứng tới khắp mọi nơi từ triết học,
	hội họa, điện ảnh cho đến kiến trúc, văn học, thi ca. Cho dù hôm nay, thời đại của niềm tin và tư duy thần thoại đã lùi vào quá khứ, cung điện Olympe 
	của các vị thần hẳn đã dời đến một hành tinh nào khác xa xăm, thì những cái tên như Zeus, Éros, Héraclès… hay Achille vẫn truyền cho loài người những 
	âm hưởng thánh thần để chinh phục ngày mai.'),

	('MS002', 'TL004', N'Tôi Là Ai – Và Nếu Vậy Thì Bao Nhiêu?','TLA.jpg',N'Richard David Precht',0,0,1993,N'Tôi là ai - và nếu vậy thì bao nhiêu? Một chuyến du hành 
	triết luận là một cuốn sách phi hư cấu được viết bởi nhà báo người Đức Richard David Precht năm 2007. Quyển sách đứng đầu danh sách bán chạy nhất của tạp
	chí Der Spiegel 16 tuần trong năm 2008 và tiếp tục ở trong danh sách đến tận tháng 10 năm 2012. Tác giả kể chuyện triết học một cách dễ hiểu và hấp dẫn, sử
	dụng những kết quả nghiên cứu của khoa học về não bộ, tâm lý, sinh học, y học làm viện chứng hoặc bác bỏ những luận thuyết triết học từng được đưa ra trong 
	suốt chiều dài lịch sử, kể từ Platon, Decartes, Kant, Jeremy Bentham, Nietzsche, Freud, Ernst Mach, Sartre, Peter Singer, Niklas Luhmann... Mục đích của cuốn
	sách là đánh thức và rèn luyện tính tò mò ham hiểu biết và khuyến khích một cuộc sống tiến bộ, có ý thức hơn.')
go

insert into SACH values 
	('MS003', 'TL005', N'Mụ Phù Thủy','MPT.jpg',N'Gloria Ericson',0,0,2010,N'“Vì chúng tôi không tìm thấy người bà con nào, trong khi dường như ông là người liên lạc thư từ và là khách thăm duy nhất của bà ấy nên chúng tôi xin báo cho ông biết là bà Miriam Winters đã qua đời. Bà ấy chết thanh thản trong giấc ngủ vào ngày 25 vừa qua”. 

	Ánh nắng đang chiếu qua mành cửa sổ văn phòng tôi bỗng trở nên lạnh lẽo. Tôi đang đứng khi mở bức thư, bây giờ, tôi đã ngồi xuống, xoay cái ghế bọc da một vòng, nhìn đăm đăm ra cửa sổ. Thế là, sau cùng, bà ấy đã chết. “Khách thăm duy nhất”. Lạy Chúa, không hẳn thế ! Lần sau cùng gặp bà ấy là khi nào nhỉ ? Năm năm ? Sáu năm ?'),
	
	('MS004', 'TL005', N'Căn Phòng Cấm','CPC.jpg',N'R.L. Stine',0,0,2008,N'R.L. STINE là bút hiệu của Robert Lawrence Stine.

	Ông sinh ngày 8 tháng 10 năm 1943 tại Columbus (Ohio), là một nhà văn Mỹ, tác giả của hơn 12 truyện khoa học giả tưởng kinh dị dành cho độc giả thuộc lứa tuổi thanh thiếu niên. Những tác phẩm ấy được biết đến nhiều nhất là Goosebumps, Rotten School, Mostly Ghostly, The Nightmare Room và Fear Street.

	Sách của ông được dịch ra thành 32 sinh ngữ và đã được
	bán hơn 300 triệu bản trên toàn thế giới. Liên tiếp trong 3 năm từ 1990, nhật báo USA Today đã mệnh danh ông là tác giả có sách bán chạy nhất của Hoa Kỳ.'),
	
	('MS005', 'TL006', N'Khổng Minh Gia Cát Lượng Đại Truyện','KMGCLDT.jpg',N'Trần Vǎn Đức',0,0,2015,N'Gia Cát Lượng (Trung: 诸葛亮 <諸葛亮> (Gia Cát Lượng)/ Zhūge Liàng) tự là Khổng Minh (181–234), hiệu là Ngọa Long tiên sinh, là vị quân sư và đại thần của nước Thục thời hậu Hán. Ông là một chính trị gia, nhà quân sự, học giả và cũng là một nhà phát minh kỹ thuật. Trong quân sự, ông đã tạo ra các chiến thuật như: Bát Quái trận đồ (Hình vẽ tám trận), Liên nỏ (Nỏ Liên Châu, tên bắn ra liên tục), Mộc ngưu lưu mã (trâu gỗ ngựa máy). Tương truyền ông còn là người chế ra đèn trời (Khổng Minh đăng – một dạng khinh khí cầu cỡ nhỏ) và món màn thầu. Thân thế Gia Cát Lượng được biết tới nhiều qua tác phẩm Tam Quốc Diễn Nghĩa.'),

	('MS006', 'TL007', N'Chị Em Khác Mẹ','CEKM.jpg',N'Thụy Ý',0,0,2016,N'Đề tài “mẹ ghẻ con chồng” không còn là mới lạ

	Việc nuôi một đứa con gái khác của người đàn ông mình yêu thương, phải chịu sự hiện diện vô hình của một người phụ nữ nữa, bóng hình họ xuất hiện bên cạnh đứa con riêng đó dù họ đã không còn trên đời, sự cay đắng ghen tị khi bản thân mình phải chăm sóc thêm cho một người không phải con mình, mà còn là kết quả từ tình yêu của chồng với cô gái khác,…tâm trạng và cảm giác đó không ai trải qua sẽ không thể nào hiểu nổi

	Nhưng nói đi cũng nói lại
	Con gái riêng của chồng cũng chỉ là một đứa bé, nó không có tội gì cả, nó càng không phải chịu sai lầm gì cho ba mẹ vì họ cũng đến với nhau trong yêu thương chính đáng, chỉ là không may mắn mà người mẹ ra đi quá sớm. Chính vì vậy mới có “mẹ ghẻ” và những đứa “chị em khác mẹ”
	Vậy thì cô bé nào có làm gì sai? Cớ gì phải gánh chịu sự khinh thường, bất công, sự đánh đập, chửi rủa như vậy???
	Một người mẹ hết mực thương yêu chồng con, chỉ có điều không chịu được một chút sạn, không bao dung nổi cô bé ấy
	Một cô con gái đáng thương, mẹ ra đi mãi mãi, cha không còn quan tâm yêu thương cô, quá mềm yếu và không bảo vệ được cô
	Một đứa em gái khác mẹ lại rất mực yêu quý cô, thương cô bằng cả tấm lòng, như muốn trao trả lại cho xứng đáng với tâm hồn trong sáng, lương thiện của cô
	…
	Liệu gia đình họ có thể êm ấm mà chung sống hòa bình với nhau?
	Liệu  những thành kiến, những gút mắc có được tháo gỡ?
	Người tốt liệu sẽ gặp lành?
	“Cô bé lọ lem” có thể thay đổi số mệnh của mình chăng??')
go

insert into SACH values
	('MS007', 'TL003', N'Đời Ngắn Đừng Ngủ Dài','dndnd.jpg',N'Robin Sharma',1,0,1998,N'Đời Ngắn Đừng Ngủ Dài là một cuốn sách tâm lý viết bởi nhà tâm lý học người Mỹ 
	Dr. Robin Sharma. Cuốn sách này tập trung vào việc khuyến khích người đọc tận dụng cuộc đời ngắn ngủi của mình và sống đầy đủ, có ý nghĩa.

	Bằng cách sử dụng các câu chuyện và ví dụ thực tế, Sharma giải thích rằng mỗi người đều có thể trở thành người thành công và hạnh phúc nếu họ tập trung vào mục tiêu của
	mình và làm việc chăm chỉ để đạt được mục tiêu đó. Cuốn sách này cũng đưa ra các chủ đề như cách tạo động lực bản thân, quản lý thời gian hiệu quả, và phát triển kỹ năng lãnh đạo.')
	,
	
	('MS008', 'TL003', N'Mặc Kệ Thiên Hạ – Sống Như Người Nhật','MKTH.jpg',N'Mari Tamagawa',1,0,2014,N'"Nếu bạn định than thở “Mình mệt quá” hay “Mình cảm thấy bị tổn thương”
	rồi chờ mong ai đó xoa dịu thì đừng nên làm như vậy. Tại sao ư? Bởi điều đó không những không thể giúp bạn giải quyết nỗi khổ của bản thân mà còn cứa sâu vào vết thương của bạn.

		–Quan điểm của người khác sẽ chỉ mang tới cho bạn sự băn khoăn, phiền muộn và ngày càng dồn ép bạn ...

		–Quan điểm của bản thân sẽ giúp bạn tự tin, thoải mái hơn và cỗ vũ bạn bước tiếp..'),

	('MS009', 'TL002', N'Án Tử Một Tình Yêu – The Death Of A Love','AT1TY.jpg',N'Võ Anh Thơ',2,100000,2015,N'"Tôi nhớ trước đây có tác giả nào đó đã nói thế này,
	trích lược thôi: “Con người thường gánh lấy nỗi đau do con người gây ra. Thế nhưng cũng nhờ con người mà những nỗi đau đó được xoa dịu…”, có lẽ nó thích
	hợp với câu chuyện này. Đây không hề là câu chuyện tình lãng mạn, lâm li hay cao trào ngược luyến, mà chỉ là một tác phẩm rất thực, ý nghĩa nhất mà tôi 
	viết từ trước đến nay. Một thứ tình lặng lẽ âm thầm giữa hai con người trong vai trò đặc biệt và cũng trong bối cảnh thật đặc biệt – Trại giam, nơi tối 
	tăm lẫn tội lỗi. Là câu chuyện nước mắt của những phụ nữ trong buồng giam nữ số 5, của người mẹ trẻ vì cứu con mà giết người; của cô gái đôi mươi lầm lỡ; 
	hay của người mẹ bụng mang dạ chửa bởi cái đói nghèo nên phạm tội… Khi hoàn thành tác phẩm, tôi cảm giác bản thân mình cũng đã trưởng thành hơn, cũng để 
	hiểu: Làm người chưa bao giờ dễ dàng, phải dũng cảm đến dường nào để không phải làm tổn thương ai. Và rằng: Sống, chính là phải vượt lên trên những nỗi 
	đau. Có lẽ đó cũng là nghĩa vụ của con người!'),

	('MS010', 'TL002', N'Chuỗi Án Mạng A.B.C','CAMABC.jpg',N'Agatha Christie',2,110000,1936,N' "Chuỗi Án Mạng A.B.C" là một tiểu thuyết trinh thám của nhà văn Agatha Christie,
	được xuất bản lần đầu tiên vào năm 1936. Cuốn sách kể về cuộc truy tìm kẻ giết người hàng loạt tên ABC do thám tử nổi tiếng Hercule Poirot chịu trách nhiệm giải quyết.

	Trong cuốn sách, kẻ giết người hàng loạt tên ABC gửi thư cho Poirot thông báo về những vụ án giết người sắp xảy ra. Kẻ giết người này sử dụng một phương thức giết người
	khác nhau ở mỗi vụ án và tên của nạn nhân đều bắt đầu bằng chữ cái thứ tự từ A đến C. Poirot phải sử dụng khả năng suy luận tuyệt vời để giải quyết vụ án và bắt được tên
	kẻ giết người.

	Trong quá trình điều tra, Poirot gặp nhiều nhân vật khác nhau, bao gồm cả tình báo Anh và một tên sát nhân nguy hiểm. Cuối cùng, Poirot tìm ra được tên kẻ giết người ABC
	và tiết lộ hành động của hắn trước khi bắt được hắn. ')
go

insert into NOIDUNGSACH values
	('MS001','MC001',N'Nguồn Gốc Của Thế Gian Và Của Các Vị Thần',N'Thuở xưa, trước buổi khai thiên lập địa, trước khi có thế gian và các vị thần, lúc đó chỉ có Chaos35. Đó là một vực thẳm đen ngòm, vô cùng vô tận, trống rỗng, mơ hồ, vật vờ, phiêu bạt trong khoảng không gian bao la.

		Thoạt đầu là Chaos một vực thẳm vô cùng  

		Hung dữ như biển khơi, tối đen, lang thang, hoang dã.  

		Nhà thơ Milton, người Anh, thế kỷ XVII đã diễn đạt lại quan niệm của người Hy Lạp cổ về khởi nguyên của thế gian và các vị thần bằng hai câu thơ như thế.  

		Nhưng rồi từ Chaos đã nẩy sinh ra thế gian với bao điều kỳ lạ cùng với các vị thần có một cuộc sống phong phú khác thường. Từ Chaos đã ra đời Gaia36, Đất mẹ của muôn loài, có bộ ngực mênh mông. Chính Đất mẹ-Gaia là nơi sinh cơ lập nghiệp bền vững đời đời của muôn vàn sinh linh, vạn vật.  

		Chaos lại sinh ra Érèbe-Chốn Tối tăm Vĩnh cửu và Nyx-Đêm tối Mịt mù. Nhưng chưa hết, từ Chaos lại ra đời Tartare-Địa ngục và Éros-Tình yêu. Éros là đứa con cuối cùng của Chaos nhưng lại là đứa con xinh đẹp nhất. Éros ra đời lãnh sứ mạng làm cho thần thần, người người, cỏ cây hoa lá, vạn vật muôn loài giao hòa gắn bó với nhau để tạo nên thế gian và cuộc sống vĩnh hằng bất diệt.  

		Như vậy là Chaos sinh ra năm “người con”. Với “năm người” này (ngày nay chúng ta gọi là nguyên lý) sẽ sinh sôi nảy nở ra con đàn cháu đống nối dõi đời đời.  

		Érèbe-Chốn Tối tăm Vĩnh cửu lấy Nyx-Đêm tối Mịt mù làm vợ. Họ sinh được hai người con: anh là Khí-Éther bất diệt, em là Ánh sáng trong trẻo-Héméra; Ngày-Jour ra đời từ ánh sáng này. Kể từ đó thế gian tràn ngập ánh sáng. Ngày và Đêm thay nhau ngự trị.  

		Nữ thần Đất mẹ-Gaia có bộ ngực nở nang tràn đầy sức sống. Đứa con đầu lòng của nàng là Ouranos-Bầu trời sao nhấp nhánh. Nhà thơ Hy Lạp Hésiode sống vào quãng thế kỷ VIII hoặc VII TCN, kể lại trong tập Thần hệ (Théogonie):  

		Nữ thần Đất có bộ ngực nở nang  

		Đối với mọi vật nàng là móng nền vững chắc  

		Nàng Đất tóc vàng sinh cho thế gian trước hết  

		Bầu trời sao nhấp nhánh, bạn thân thiết của nàng  

		Để Bầu trời che phủ khắp thế gian,  

		Để làm nơi cư ngụ cho các vị thần Cực lạc.  

		Nàng lại còn đẻ ra Núi-Ouréa cao vút, sừng sững, nghênh ngang và Biển-Pontos mênh mông, khi hung dữ gầm thét, lúc hiền dịu rì rào. Trời, Núi, Biển như vậy đều do nữ thần Đất mẹ-Gaia sinh ra. Chúng là những đứa con không cha, bởi vì khi ấy mẹ chúng chưa cùng ai kết bạn. Đối với thần thì điều ấy chẳng có gì đáng lạ.  

		Tiếp đó, nữ thần Đất-Gaia kết hôn với thần Bầu Trời-Ouranos. Hai người sinh ra được rất nhiều con. Chúng toàn là những người khổng lồ có sức mạnh và tài năng mà thuở ấy chưa có vị thần nào ra đời để có thể sánh bằng. Tất nhiên, sau này chúng phải quy phục trước các vị thần mới. Người ta chia những đứa con khổng lồ của Ouranos và Gaia ra làm ba loại:  

		1 – Những thần khổng lồ Titan và Titanide – Có sáu nam thần khổng lồ tên gọi chung là Titan và sáu nữ thần khổng lồ tên gọi chung là Titanide.  

		Sáu Titan là: Okéanos tức thần Đại dương, Koios, Crios, Hypérion, Japet và Cronos (thần thoại La Mã: Saturne).  

		Sáu Titanide là: Téthys, Théia, Thémis, Mnémosyne, Phoébé và Rhéa.  

		2 – Ba thần khổng lồ Cyclopes37 – Đây là những vị thần chỉ có một con mắt ở giữa trán, hung bạo khỏe mạnh chẳng kém một ai, hơn nữa lại rất khéo chân khéo tay. Họ là những người thợ rèn thiện nghệ đã làm ra không thiếu một thứ gì. Tên ba anh em là: Argès, Stéropès và Brontès.  

		3. Ba quỷ thần khổng lồ Hécatonchires38 – Những Cyclopes đã thật là quái đản nhưng những Hécatonchires lại còn quái đản hơn nhiều. Mỗi Hécatonchires có một trăm cái tay và năm chục cái đầu. Người ta thường gọi chúng là thần Trăm tay. Sức mạnh của chúng thật kinh thiên động địa, ít ai dám nghĩ đến, chỉ nghĩ đến thôi, việc đọ sức với chúng. Tên chúng là Cottos, Briarée và Gyès.  

		***  

		Như trên đã kể, Ouranos lấy Gaia làm vợ sinh được sáu trai gọi chung là Titan, sáu gái tên gọi chung là Titanide. Các Titan kết hôn với các Titanide sinh con đẻ cái để cho chúng cai quản thế gian.  

		Titan đầu tiên, con cả, là thần Okéanos. Thần cai quản mọi biển khơi, suối nguồn, sông nước. Thần đã điều hòa, sắp xếp biển, sông làm thành một con sông khổng lồ bao quanh lấy đất, che chở cho đất. Okéanos lấy Téthys đẻ ra ba nghìn trai, ba nghìn gái. Gái có tên chung là Okéanide. Đó là những tiên nữ thường trú ngụ ở dưới biển nhưng cũng ở cả sông, suối. Con trai là các thần sông cai quản mọi sông cái, sông con trên mặt đất.  

		Okéanos sống cách biệt với các anh em Titan của mình ở tận cung điện dưới đáy biển sâu. Chẳng bao giờ vị thần này tham dự các cuộc họp của thần thánh và loài người. Mặt trời, Mặt trăng và các Ngôi sao đều do Okéanos điều khiển. Chúng phải xuất hiện với thế gian rồi trở về với Okéanos. Duy chỉ có chòm sao Đại Hùng-Gande Ourse là không bao giờ chịu quy phục dưới quyền điều khiển của Okéanos.  

		Titan Koios lấy Phoébé sinh được hai con gái là Léto và Astéria. Sắc đẹp của hai chị em nhà này đã gây ra cho họ biết bao đau khổ, gian truân, một chuyện nếu kể ra ắt phải đụng đến thần Zeus.  

		Titan Hypérion lấy nữ thần Théia. Đôi vợ chồng này sinh được một trai, hai gái. Trai là Hélios-Thần Mặt trời đỏ rực, gái là Séléné-Nữ thần Mặt trăng hiền dịu và Éos-Nữ thần Rạng đông hay Bình minh có những ngón tay hồng.  

		Titan Cronos mà thần thoại La Mã gọi là Saturne lấy Rhéa sinh được ba trai, ba gái: trai là Hadès, Poséidon, Zeus; gái là Hestia, Déméter, Héra.  

		Riêng hai Titanide Thémis và Mnémosyne lúc này chưa chịu kết bạn với ai. Duyên cớ vì sao, người xưa không kể lại nên chúng ta không rõ. Vì thế hai Titan Koios và Japet phải lấy hai vị nữ thần khác không cùng huyết thống Titan.  

		Crios lấy Eurybie sinh được ba trai là các vị thần Astréos, Pallas và Persès, nổi danh lừng lẫy vì sự hiểu biết uyên thâm. Nhân đây ta cần phải kể qua cuộc tình duyên của người con cả của Titan Koios, thần Astréos. Thần lấy tiên nữ Éos-Rạng Đông có những ngón tay hồng, sinh ra cho thế gian các thần Gió hung dữ. Tuy vậy, thần Gió-Zéphyr (thần thoại La Mã: Favonius) tính khí lại rất dịu dàng. Thần đến với thế gian bằng những cử chỉ vuốt ve, âu yếm, đem đến cho loài người những đám mây đen báo trước những cơn mưa mát dạ mát lòng. Chúng ta thường gọi Zéphyr là thần Gió Tây. Còn thần Gió Bấc-Borée (thần thoại La Mã: Septentrion) có bước đi nhanh, ít thần Gió nào sánh kịp, vì thế thần đem đến cho loài người không ít lo âu. Thần Gió Nam-Notos (thần thoại La Mã: Auster) ấm áp. Thần Gió Tây Nam-Euros (thần thoại La Mã: Vulturnus)39 mát mẻ, dịu dàng. Cả đến những ngôi sao hằng hà sa số thao thức vằng vặc suốt đêm trên bầu trời bao la cũng là con của Astréos và Éos.  

		Cũng cần phải kể thêm một chút nữa là Éos còn có nhiều cuộc tình duyên với các vị thần khác và cả với người trần để sinh con đẻ cháu cho thế gian đông đúc vui tươi.  

		Titan Japet lấy một tiên nữ Okéanide tên là Clymène. Họ sinh được bốn con trai là: Atlas, Prométhée, Epiméthée, và Ménétios.  

		Thế còn hai Titanide Thémis và Mnémosyne không “lấy chồng” thì làm gì? Xin thưa, thế giới thần thánh xưa kia không để cho ai ăn không ngồi rồi cả. Ai ai cũng có những công việc phải làm tròn. Thémis là vị nữ thần Pháp luật, Công lý, sự Cân bằng, Ổn định tối cao do Quy luật và Trật tự tạo nên. Nhờ có Thémis thế gian mới ổn định và phát triển hài hòa. Nàng là người có tài nhìn xa trông rộng, hiểu biết, khôn ngoan. Còn Mnémosyne là nữ thần của Trí nhớ, Ký ức. Nhờ có Mnémosyne mà con người lưu giữ được kinh nghiệm và sự hiểu biết để ngày càng khôn lớn, giỏi giang.  

		Đó là chuyện về lớp con đầu của Ouranos và Gaia, những Titan và Titanide cùng đôi chút về con cháu họ. Tất nhiên nếu lần theo tộc phả từng chi, từng ngành thì còn biết bao nhiêu chuyện.  

		Về nguồn gốc của thế gian còn có một cách kể hơi khác một chút. Nhà viết hài kịch cổ đại Hy Lạp, Aristophane thế kỷ V TCN viết:  

		Đêm tối có đôi cánh đen  

		Đem một quả trứng sinh ra từ gió  

		Đặt vào lòng Érèbe tối đen, sâu thẳm, mịt mù  

		Và trong khi bốn mùa thay nhau qua lại  

		Thì cả không gian hằng hằng mong đợi  

		Thần Tình yêu đến với đôi cánh vàng ngời ngợi chói lòa.  

		Cách giải thích này rõ ràng không giống với câu chuyện vừa kể trên. Đó là cách giải thích theo quan niệm của học thuyết thần thoại tôn giáo Orphisme, một học thuyết ra đời muộn hơn, vào quãng thế kỷ VIII TCN.  

		… Thuở xưa, trước buổi khai thiên lập địa chỉ có Chaos. Chaos là một vực thẳm trống rỗng, tối tăm nảy sinh từ Thời gian Vĩnh viễn-Chronos40. Lửa, Nước, Không khí cũng từ Chronos mà ra, và nhờ có chúng các vị thần mới có thể kế tiếp nhau ra đời hết thế hệ này đến thế hệ khác.  

		Đêm tối-Nyx và Sương mù đều cư ngụ trong lòng Chronos. Sương mù kết đọng lại thành một quả trứng khổng lồ. Và đã có trứng thể tất có ngày trứng phải nở.  

		Quả trứng đã nở ra một vị thiên thần tươi trẻ, xinh đẹp có đôi cánh vàng. Vừa ra khỏi vỏ trứng vị thần này liền lấy hai tay dâng một nửa vỏ trứng lên cao và đạp nửa vỏ sau xuống dưới chân mình. Thế là Trời-Ouranos và Đất-Gaia hình thành. Còn vị thiên thần tươi trẻ xinh đẹp là thần Tình yêu-Éros. Éros là một vị thần có quyền lực đặc biệt; thần có tài làm cho vạn vật muôn loài, từ các vị thần cho đến con người, súc vật, cỏ cây hoa lá, thậm chí cả núi non sông biển giao hòa gắn bó với nhau. Thần đã gom góp, kết hợp mọi vật ở thế gian này để tạo ra cuộc sống. Mà quả thật như vậy, nếu như Trời và Đất không “âu yếm” nhau thì tại sao Trời không xa nổi Đất? Tại sao Trời không bỏ Đất mà đi để mặc Đất sống cô đơn, trơ trọi một mình, không ai che chở trong cõi Hư không tối tăm lạnh lẽo? Chính vì Trời đã “âu yếm” Đất nên đã chiếu rọi xuống Đất ánh sáng và khí nóng, đã tưới tắm cho Đất những cơn mưa ẩm mát để cho mùa màng tươi tốt, hoa thắm cỏ xanh. Còn Đất, để đền đáp lại tình yêu của Trời, tình yêu của Éros ban cho, Đất đã thai nghén ấp ủ trong lòng những hạt giống và làm cho chúng nảy mầm đâm nhánh. Đất đã truyền đi nhựa sống của mình nuôi cỏ hoa cây cối. Và có phải để “làm dáng” với Trời mà Đất luôn luôn thay đổi y phục và đồ trang sức, khi thì xanh xanh bát ngát, khi thì vàng rượi óng chuốt một màu? Lại có lúc Trời bận việc đi xa để Đất nhớ, nhớ đến héo hon, ủ rũ, âu sầu!' 
		),
		('MS001','MC002',N'Cronos Lật Đổ Ouranos',N'Ouranos và Gaia, như trên đã kể, sinh ra ba loại con khổng lồ. Đối với những đứa con Cyclopes và Hécatonchires, Ouranos rất ghét. Hình như Ouranos thấy sự có mặt của chúng là một điều ô nhục đối với mình. Thần nghĩ ra một cách để tống chúng đi cho khuất mắt: đầy chúng xuống địa ngục Tratar, nơi sâu thẳm kiệt cùng dưới lòng đất.  

		Nữ thần Gaia hoàn toàn không bằng lòng với chồng về cách đối xử với lũ con Cyclopes và Hécatonchires của bà như vậy. Bà tìm đến đám con Titan, xui giục các Titan chống lại bố. Nhưng chẳng một Titan nào dám nghe theo lời mẹ. Duy chỉ có Titan Cronos là dám đảm nhận công việc tày đình ấy. Theo mưu kế của mẹ, được mẹ giao cho một lưỡi hái, Cronos rình nấp chờ lúc Ouranos vào giường ngủ, chém chết Ouranos41.  

		Máu của Ouranos-Trời chảy xuống Gaia-Đất sinh ra một thế hệ khổng lồ thứ tư mà so với các Cyclopes và Hécatonchires, thế hệ này nếu không hơn thì cũng chẳng hề mảy may thua kém. Đây là những khổng lồ Gigantos42 có thể gọi là Đại khổng lồ, thân hình cao lớn, khiên giáp sáng ngời, trong tay lúc nào cũng lăm lăm ngọn lao dài nhọn hoắt, mặt mày dữ tợn gớm ghiếc.  

		Máu của Ouranos còn sinh ra những nữ thần Érinyes (thần thoại La Mã: Furies)43 tay cầm roi, tay cầm đuốc, mái tóc là một búi rắn độc ngoằn ngoèo vươn đầu ra tua tủa, ai trông thấy cũng phải cao chạy xa bay. Những nữ thần này lãnh sứ mạng trừng phạt báo thù kẻ phạm tội bằng cách giày vò trái tim kẻ đó suốt đêm ngày khiến cho y ăn không ngon, ngủ không yên, lúc nào cũng bồn chồn, day dứt.  

		Người ta còn kể, những giọt máu của Ouranos nhỏ xuống biển đã sinh ra nữ thần Tình yêu và Sắc đẹp Aphrodite.  

		***  

		Con cái của Ouranos rất nhiều. Người ta tính ra Ouranos có khoảng từ 12 đến 45 đứa con. Vào thế kỷ I TCN nhà học giả Diodore đảo Sicile44 trong tác phẩm Tủ sách lịch sử45 đã sưu tầm và kể lại các huyền thoại. Huyền thoại về Ouranos, dưới ngòi bút của ông, lúc này đã ít nhiều mang ảnh hưởng của lý thuyết về huyền thoại của Évhémère46, một lý thuyết giải thích thần thoại có tính chất duy vật và duy lý còn sơ lược và ngây thơ. Diodore cho rằng Ouranos là vị vua đầu tiên của những người Atlante sống trên bờ Okéanos. Ouranos đã truyền dạy cho dân mình khoa học, kỹ thuật, bản thân nhà vua là người rất am hiểu khoa học, kỹ thuật và thường say mê theo dõi thiên văn. Vì thế sau khi Ouranos chết, nhân dân đã thần thánh hóa ông và dần dần người ta đồng nhất ông với bầu trời. Cũng theo nhà học giả này, Ouranos có 45 con, 18 đứa trong số đó là con của Ouranos với Tita. Vì thế mới có cái tên Titan. Sau này Tita đổi tên là Gaia. Cách giải thích của Diodore chắc chắn là không đủ sức thuyết phục khoa học. Nhưng chúng ta cần biết qua để thấy được một cố gắng của các nhà học giả cổ đại muốn tìm hiểu hạt nhân hiện thực trong huyền thoại.  

		Về nữ thần Gaia không phải chỉ sinh nở có thế. Nàng còn có nhiều cuộc tình duyên và mỗi cuộc tình đều đem lại cho thế gian những vị thần này, thần khác. Kết hôn với thần Biển-Pontos, con mình, Gaia sinh ra các thần Biển: Nérée, Phorcys, Thaumas, Céto. Kết hôn với Tartare, Gaia sinh ra Typhon, một quỷ thần có trăm đầu là rắn phun ra lửa, to lớn khổng lồ có dễ còn hơn cả thế hệ khổng lồ Hécatonchires lớp trước. Có chuyện còn kể Gaia sinh ra cả lũ ác điểu Harpies, con mãng xà Python…  

		Là nữ thần Đất Mẹ, Gaia có một vị trí rất lớn, rất quan trọng trong tín ngưỡng của người Hy Lạp cổ. Gaia được coi như là vị cao tằng tổ mẫu của loài người, là nơi cư ngụ cho những người trần thế, nuôi sống họ đồng thời cũng là nơi an nghỉ của họ, khi họ đã kết thúc cuộc sống tươi vui của mình trên mặt đất tràn đầy ánh sáng để bước vào cuộc sống ở thế giới khác. Nàng là khởi đầu và kết thúc của sự sống. Nàng còn được coi là người nuôi dưỡng mùa màng, cây cối cho được tươi tốt, bội thu, sinh con kết trái. Vì thế Gaia có một biệt danh là Carpophorus, nghĩa là Gaia-Được mùa. Khắp nơi trên đất nước Hy Lạp xưa đâu đâu cũng thờ cúng Gaia. Trong những lời thề nguyền thiêng liêng, người Hy Lạp thường viện dẫn Gaia để chứng giám.  

		Ở vùng Dodone, Tây Bắc Hy Lạp, sau này người ta coi Gaia như là vợ của Zeus, đẩy lùi hình ảnh Dioné, Héra, Déméter xuống vị trí thứ yếu.  

		***  

		Nữ thần Đêm tối-Nyx sinh ra rất nhiều vị thần tai hại cho thế gian và loài người. Đó là những nữ thần Kères có đôi cánh đen, chân có móng sắc nhọn, khoác một tấm áo lúc nào cũng thấm ướt máu người. Các nữ thần Kères thường hạ cánh xuống nơi chiến địa để hút máu, ăn thịt những người đã chết. Đây là những nữ thần Chết khác với thần Thanatos, một nam thần cũng là con của Nyx, lãnh sứ mạng đi báo tử cho những kẻ bất hạnh mà thật ra người Hy Lạp xưa kia cũng coi Thanatos như là thần Chết. Tiếp đến là thần Giấc ngủ-Hypnos47 còn gọi là thần Giấc mộng, nữ thần Bất hòa-Éris.  

		Trong số con gái của nữ thần Nyx ta không thể không nhắc đến vị nữ thần Đấu tranh. Giống như mẹ, vị nữ thần này lại đẻ ra một loạt các thần tai hại khác như Mỏi mệt, Đói khổ, Đau thương, Hỗn loạn, Gây gổ, Cướp bóc, Chém giết…  

		Chưa hết, Đêm tối-Nyx còn sinh ra ba chị em nữ thần Moires (thần thoại La Mã: Parques hoặc Tri Fata)48 cai quản Số mệnh của thần thánh và loài người. Số mệnh này là cuộn chỉ trong tay nữ thần Clotho (thần thoại La Mã: Nona). Nàng quay cuộn chỉ để cho nữ thần Lachésis (thần thoại La Mã: Decima) giám định. Chiểu theo sự giám định này, nữ thần Atropos (thần thoại La Mã: Morta) tay cầm kéo lạnh lùng cắt từng đoạn chỉ-Số mệnh của chúng ta. Thật bất hạnh cho ai bị lưỡi kéo của Atropos cắt đoạn chỉ-Số mệnh của mình. Người đó sẽ buộc phải từ bỏ cuộc sống êm dịu, ngọt ngào như mật ong vàng để về sống dưới địa ngục Tartare.  

		Ta còn phải kể đến nữ thần Némésis một người con gái của nữ thần Đêm tối-Nyx, đảm đương công việc trừng phạt, trả thù đối với những kẻ phạm tội để giữ gìn luân thường đạo lý và sự công bằng. Nàng còn là vị nữ thần gìn giữ sự mực thước trong đời sống. Những thói kiêu căng, ngạo mạn của người trần thế muốn vượt lên thần thánh, rồi những hoàn cảnh ỷ thế giàu sang, có quyền có lực làm càn, làm bậy, cùng những hành động thái quá như xa hoa, tự phụ, ức hiếp lương dân đều không qua được con mắt nữ thần Némésis.  

		Đó là tóm tắt câu chuyện về buổi khai thiên lập địa, thế gian từ chỗ hoang vu, hỗn độn đến chỗ có hình dáng và có thần cai quản. Nhưng lúc này đây mọi thứ còn hết sức bề bộn ngổn ngang, chưa ổn định, chưa trật tự, cân bằng. Cronos cướp ngôi của Ouranos cai quản thế gian với tất cả nỗi khó khăn như vậy.  

		Thần thoại về buổi khai thiên lập địa của người Hy Lạp có những nét tương đồng với thần thoại của nhiều dân tộc trên thế giới mà khoa thần thoại học so sánh (comparatif mythologie) đã khảo sát thấy. Đó là môtíp về việc tách đất ra khỏi trời, về việc tống giam những đứa con của đất vào lòng đất.  
		Đọc thần thoại Ấn Độ chúng ta thấy: Thuở khởi đầu của vũ trụ chỉ là nước mênh mông, không có cả Cái Tồn tại và Cái Không tồn tại49. Sau dần Nước thai nghén Mặt trời, Cái Không tồn tại vốn ở trong lòng Đất sinh ra cái Tồn tại. Và giai đoạn đầu của sự sáng tạo ra thế gian là phải tách cái Tồn tại ra khỏi Cái Không tồn tại. Cái Tồn tại là thế giới của người và thần, của Mặt trời, Khí nóng và Nước, Trời và Đất là những vị thần đầu tiên. Cái Không tồn tại là phạm vi của yêu ma quỉ quái, chỉ có bóng tối lạnh lẽo. Lại có cách giải thích khởi nguyên của vũ trụ là do tình ái: “Khi Shiva và Shakti giao hợp, tia lửa, lạc thú xuất hiện và vũ trụ phát sinh do tình ái…”50, “… Shiva tự phân làm hai nửa, một âm và một dương, âm dương giao hòa thành vũ trụ…”51. Thần Indra theo một giả thuyết là con của Trời và Đất được thai nghén và sinh ra vào lúc mà hai vị thần này còn sống chung với nhau ở cùng một chỗ. Indra nhờ uống được thứ rượu thần là soma bỗng vụt lớn lên thành người khổng lồ có sức mạnh vô địch khiến bố, mẹ của Indra – Trời và Đất – vô cùng khiếp sợ, bỏ chạy. Nhưng mỗi người chạy đi một phía ngược chiều với nhau vì thế mà họ xa nhau vĩnh viễn. Còn Indra thì chiếm lấy khoảng không gian giữa Trời và Đất. Ở thần thoại Trung Quốc có truyện ông Bàn Cổ và bà Nữ Oa. Còn thần thoại Việt Nam có truyện thần Trụ Trời.' 
		)
go
insert into NOIDUNGSACH values
		('MS002','MC001',N'Loài thú tinh khôn trong vũ trụ. Sự Thật là gì?',N'“Ở một xó xỉnh nào đó của vũ trụ bao la với hằng hà hệ thống mặt trời lung linh có một hành tinh, trên đó có những con vật tinh khôn khám phá ra sự hiểu biết. đó là giây phút kiêu hãnh và dễ hiểu lầm nhất của „lịch sử thế giới”: nhưng chỉ kéo dài một giây phút mà thôi. Sau vài nhịp thở của thiên nhiên, hành tinh khô cứng lại, và loài thú khôn ngoan sống trên đó phải chết. đấy có thể là một câu truyện ngụ ngôn tưởng tượng của một ai đó nghĩ ra. Nhưng câu truyện này cũng chưa nói lên được hết sự nghèo nàn, hư ảo, chóng qua, vô tích sự và tuỳ tiện của trí khôn con người trong thiên nhiên; trí khôn con người không phải là chuyện muôn thủa. Một khi trí khôn đó qua đi, thì mọi sự cũng mất hết dấu vết. Là vì trí khôn này chẳng có thêm sứ mạng nào khác ngoài chính cuộc sống con người. Trí khôn này hoàn toàn mang tính người, và chỉ có người sở hữu và tạo ra nó mới say mê nó, coi nó như là chìa khóa đi vào thế giới. Nếu chúng ta hiểu được loài muỗi, thì chúng ta sẽ nhận ra, là chúng cũng có sự đắm say đó và chúng cũng nghĩ mình là cái rốn của vũ trụ quay cuồng“.   

		Con người là một loài vật tinh khôn, nhưng loài vật này lại tự đánh giá mình quá cao. Là bởi vì lí trí của con người không hướng về Chân lí lớn lao, mà chỉ quan tâm tới những cái nhỏ nhặt trong cuộc sống. Trong lịch sử triết học, có lẽ chẳng có đoạn văn nào mô tả con người thơ mộng và triệt để hơn đoạn trên đây. đó là đoạn mở đầu có lẽ đẹp nhất của một tác phẩm triết học năm 1873 với tựa đề: Über Wahrheit und Lüge im außermoralischen Sinne (Về sự thật và dối trá bên ngoài í nghĩa đạo đức). Tác giả của nó là Friedrich Nietzsche, một giáo sư Cổ ngữ học 29 tuổi của đại học Basel, Thuỵ-sĩ.   

		Nhưng Nietzsche đã không cho xuất bản cuốn sách nói về loài vật tinh khôn và kiêu căng này. Trái lại, ông phải mang thương tích nặng nề, vì đã viết một tác phẩm bàn về nền tảng văn hoá hi-lạp. Những người phê bình khám phá ra sách này là một tài liệu thiếu khoa học và chứa đựng những phỏng đoán vu vơ. Mà quả đúng như thế. Ông bị thiên hạ chê là một thiên tài lạc lối, và danh tiếng một nhà cổ ngữ nơi ông xem ra cũng theo đó mà tiêu tan.  

		Khởi đầu, thiên hạ kì vọng rất nhiều nơi ông. Cậu bé Fritz sinh năm 1844 tại làng Röcken vùng Sachsen và lớn lên tại Naumburg bên bờ sông Saale. Cậu nổi tiếng thần đồng. Cha cậu là một mục sư coi xứ, và mẹ cũng rất đạo đức. Khi Fritz được bốn tuổi thì cha mất, không lâu sau đó người em trai cũng mất. Mẹ đưa cậu về Naumburg, và từ đó Fritz lớn lên trong một gia đình toàn là nữ giới. Hết tiểu học, Fritz vào trung học của giáo phận và sau đó vào một nội trú danh tiếng, đâu đâu cậu cũng được tiếng thông minh. Năm 1864, cậu ghi danh học Ngôn ngữ cổ điển và Thần học tại đại học Bonn. Nhưng sau một bán niên, Fritz bỏ Thần học. Fritz muốn làm mục sư để hài lòng mẹ, nhưng „ông mục sư non“ – tiếng con nít vùng Naumberg vẫn trêu chọc cậu – đã sớm mất niềm tin vào Chúa. Fritz cảm thấy quá tù tùng khi sống với mẹ, với niềm tin và với đời mục sư. Anh quyết định thoát ra khỏi mọi thứ đó, nhưng cuộc chuyển hướng này đã gặm nhấm tâm hồn anh suốt cả đời.  Sau một năm, Nietzsche và vị giáo sư của anh chuyển tới Leipzig. Ông thầy rất quý cậu học trò thông minh của mình, nên đã khuyên anh nhận chân giáo sư tại đại học Basel. Năm 1869, lúc 25 tuổi, Nietzsche trở thành giáo sư thỉnh giảng. đại học Basel cấp tốc trao cho anh bằng tiến sĩ và bằng lên ngạch giáo sư (Habilitation). Ở Thuỵ-sĩ, Nietzsche làm quen với giới văn nghệ sĩ cùng thời, trong đó có Richard Wagner và bà vợ Cosima, mà Nietzsche đã có dịp gặp ở Leipzig. Nietzsche quá mê nhạc Wagner đến độ cảm hứng viết ra cuốn Die Geburt der Tragödie aus dem Geist der Musik (Tinh thần âm nhạc đã khai sinh ra Bi kịch) vào năm 1872.  

		Cuốn sách là một thất bại, và nó cũng bị quên nhanh. Lí do là vì từ đầu thời Lãng mạn, người ta đã nói tới mâu thuẫn giữa cái gọi là tính „sáng tạo xuất thần“ (Dionysischen) của âm nhạc và cái „thể cách chân phương“ (Appolinischen) của nghệ thuật tạo hình rồi, và kinh nghiệm lịch sử cũng đã cho thấy, hai cái đó chỉ là những phỏng đoán mà thôi. Thành ra, điều Nietzsche bàn tới trong sách chẳng có gì mới. Hơn nữa, thế giới học giả âu châu thời đó đang bận tâm tới sự hình thành của một bi kịch khác, quan trọng hơn. Một năm trước đó, xuất hiện cuốn sách Về Nguồn Gốc Con Người từ thú vật của Charles Darwin, nhà thần học và thực vật học nổi tiếng người Anh. Từ lâu rồi, ít nhất từ mười hai năm trước khi sách Darwin ra đời, đã có quan điểm cho rằng, con người có thể được tiến hoá dần từ những hình thái nguyên sơ trước đó. Nhưng trong Sự Hình Thành Các Chủng Loại, vì chính Darwin đã hé mở cho biết, có thể con người cũng từ loài vật mà thành, nên tác phẩm bán chạy như tôm tươi. Trong những năm 1860, nhiều nhà khoa học tự nhiên cũng đi tới một kết luận như vậy, và họ nối con người vào liên hệ với loài khỉ đột vừa được khám phá. Mãi cho tới cuộc thế chiến thứ nhất, Giáo hội Kitô giáo, đặc biệt ở đức, chống lại Darwin và những người ủng hộ ông. Nhưng ngay từ đầu ai cũng biết rằng, sẽ chẳng có một sự lùi bước tự nguyện nào nữa để quay trở về cái vũ trụ quan của thời trước đó. Người ta không còn tin vào chuyện Thiên Chúa là đấng trực tiếp tạo dựng và điều khiển con người nữa. Và các khoa học tự nhiên giờ đây ăn mừng chiến thắng của họ với một hình ảnh về con người rất thực tế: Họ bỏ Thiên Chúa để quay sang quan tâm tới khỉ. Và hình ảnh cao cả của con người như một thụ tạo giống Thiên Chúa bị vỡ ra làm hai: một đàng, sự cao cả này không còn khả tín nữa và đàng khác, con người giờ đây không hơn không kém đượi coi như là một loài thú thông minh mà thôi.  

		Nietzsche phấn chấn vô cùng trước cảnh quan vũ trụ mới đó. Về sau, có lần ông viết: „Tất cả cái mà chúng ta cần, đó là một (công thức) hoá học cho các quan niệm đạo đức, tôn giáo, nghệ thuật và cho những cảm nhận cũng như tất cả những cảm xúc mà ta có được trước những tiếp xúc lớn nhỏ với văn hoá và xã hội, với cả nỗi cô đơn.“ Hơn ba chục năm cuối của thế kỉ 19 nhiều nhà khoa học và triết gia đã đổ công tìm kiếm chính cái hoá học đó: Họ đi tìm một giải thích sinh học cho sự sống mà chẳng cần gì tới Thiên Chúa nữa. Nhưng chính Nietzsche thì lại chẳng quan tâm một tí gì tới cuộc tìm kiếm đó. Ông quan tâm tới chuyện hoàn toàn khác: đâu là í nghĩa của cái nhìn thực tế kia của khoa học đối với thân phận con người? Nó giúp con người lớn lên hay làm nó bé lại? Khi nhìn được rõ hơn về chính mình, con người giờ đây được thêm gì hay lại mất cả chì lẫn chài? Trong tình hình đó, ông viết luận văn Wahrheit und Lüge (Sự thật và dối trá), có lẽ đây là tác phẩm tuyệt nhất của ông.  

		Câu hỏi, con người bé đi hay lớn lên, được Nietzsche trả lời là tuỳ theo tâm trạng. Khi con người bất hạnh – và đây là tâm trạng thường thấy nơi con người – lúc đó họ cảm thấy bị đè nén, hối tiếc và nói ra toàn chuyện dở hơi. Ngược lại, lúc vui vẻ, họ có những cảm xúc tự hào và mơ thành siêu nhân. Có một mâu thuẫn ghê gớm giữa những tưởng tượng ngạo mạn và giọng điệu tự tin sấm sét trong các tác phẩm của Nietzsche và diện mạo thật của ông: một dáng người nhỏ con, hơi phì, nhút nhát. Bộ ria mép lì lợm với một cây lược vừa vặn làm cho khuôn mặt ông mang nét cứng rắn và nam nhi hơn, nhưng nhiều căn bệnh thủa thiếu thời đã ăn mòn thể lực và tinh thần của ông. Ông bị cận nặng, luôn bị dằn vặt bởi những cơn đau bao tử và đau đầu. Năm 35 tuổi, ông cảm thấy kiệt sức hoàn toàn và phải thôi dạy học ở Basel. Có lẽ chứng bệnh lậu, thường được thiên hạ xa gần nói tới, đã góp thêm phần dứt điểm đời ông.  

		Mùa hè năm 1881, hai năm sau khi từ giã đại học, tình cờ Nietzsche khám phá ra một thiên đường hạ giới cho chính mình, đó là địa điểm Sils Maria trong vùng Oberengadin thuộc Thụy-sĩ. Một cảnh trí tuyệt vời, giúp ông có được những phấn chấn và động lực sáng tạo. Từ đó đều đặn hàng năm, ông tới đây để một mình đi dạo và đắm mình trong suy nghĩ. Nhiều tư tưởng hình thành ở đây đã được ông viết ra trong mùa đông ở Rapallo, ở bờ biển địa Trung, ở Genua và ở Nizza. đa số những tư tưởng đó cho thấy Nietzsche là một nhà phê bình bén nhạy, triệt để và có nhiều đòi hỏi về mặt văn chương. Ông đã đánh đúng vào những vết thương của triết học phương tây. Nhưng những đề nghị của riêng ông về một thuyết nhận thức mới và một nền đạo đức mới thì, ngược lại, lại dựa hoàn toàn trên thuyết tiến hoá xã hội chưa chín mùi của Darwin và thường chạy trốn vào trong những thị hiếu thời trang quay cuồng. Thành ra, điều ông viết càng mạnh mẽ bao nhiêu thì lại càng như những quả đấm vào không khí bấy nhiêu. „Thiên Chúa đã chết“ – câu ông viết đi viết lại nhiều lần – thật ra những người đồng thời với ông, cả Darwin và những tác giả khác trước đó, cũng đều đã biết rồi.  

		Năm 1887, khi ngắm nhìn những ngọn núi phủ đầy tuyết của Sils Maria lần cuối, Nietzsche tái khám phá ra sự giới hạn nhận thức của các con vật tinh khôn, mà ông đã có lần đề cập tới trong một luận văn trước đây của mình. Trong tác phẩm bút chiến Zur Genealogie der Moral (Về hệ tộc của đạo đức), ông mở đầu với câu: „Chúng ta, những kẻ có khả năng nhận biết, lại chẳng biết mình là ai, chúng ta chẳng biết chính mình: điều này không lạ gì cả. Chúng ta đã chẳng bao giờ tìm hiểu mình – chuyện gì sẽ xẩy ra, nếu một ngày nào đó chúng ta nhận ra ta?“ Nietzsche thường dùng ngôi thứ nhất số nhiều để nói về chính mình; ông thường nói về một loài vật rất đặc biệt, mà ông là người đầu tiên mô tả: „Gia tài của chúng ta ở nơi các tổ ong nhận thức của chúng ta. Chúng ta được sinh ra như những con vật có cánh và những kẻ góp mật của tinh thần, luôn trên đường tìm tới các tổ ong kia, chúng ta chỉ thích quan tâm tới một điều mà thôi, đó là „mang về nhà“ cho mình một cái gì đó”. Nietzsche chẳng còn nhiều thời gian để sáng tác. Hai năm sau, ông bị suy sụp thần kinh khi còn ở Turin. Bà mẹ mang đứa con 44 tuổi từ Íđại-lợi về một bệnh viện ở Jena. Sau đó, ông sống với mẹ, nhưng chẳng còn viết được gì nữa. Tám năm sau, mẹ mất, ông phải sống với cô em gái khó ưa của mình. Ngày 25 tháng 8 năm 1900 ông mất ở Weimar, thọ 55 tuổi.  

		Lòng tự tin của Nietzsche, điều mà ông luôn biện hộ bằng giấy bút, thật lớn: „Tôi biết số phận của tôi, nó sẽ gắn liền với tên tuổi của tôi và làm cho người ta nhớ tới một điều gì khủng khiếp“. Quả thật, cái khủng khiếp đó đã biến ông trở thành một trong những triết gia có ảnh hưởng nhất trong thế kỉ hai mươi đang đến. Vậy đâu là nội dung của cái lớn lao đó?  

		đóng góp lớn nhất của Nietzsche là sự phê bình hăng say và triệt để của ông. Hơn tất cả  

		các triết gia trước đó, ông say mê vạch ra cho thấy cái hống hách và ngớ ngẩn của con người, khi họ dùng tiêu chuẩn lô-gích và sự thật của „chủng vật người“ để đánh giá thế giới mà họ đang sống trên đó. „Loài thú tinh khôn“ nghĩ rằng, chúng có một vị trí đặc biệt chẳng loài nào khác có được. Nietzsche trái lại quả quyết rằng, con người không hơn không kém chỉ là một con vật và suy nghĩ của nó cũng không khác chi một con vật, nghĩa là suy nghĩ của nó cũng bị điều chế bởi bản năng và dục vọng, bởi í muốn thô thiển cũng như bởi khả năng nhận thức giới hạn của nó. Như vậy, đa số triết gia tây phương đã lầm, khi họ coi con người là một cái gì đó hoàn toàn đặc biệt, như một thứ máy điện tử có công suất lớn về khả năng tự nhận thức. Có thật con người có thể tự nhận biết mình và nhận biết được thực tại khách quan không? Con người có thật có khả năng đó không? Hầu hết triết gia trước nay đều trả lời có. Cũng có một vài triết gia chưa bao giờ đặt ra cho mình câu hỏi đó. Họ đương nhiên cho rằng, trí khôn của con người cũng đồng thời là một thứ tinh anh của hoàn vũ. Họ không coi con người là một loài thú khôn ngoan, mà xác định chúng là một thực thể thuộc vào một cấp hoàn toàn khác. Họ chối bỏ thẳng thừng mọi gia sản phát sinh từ gốc rễ thú vật nơi con người. Hết triết gia này đến triết gia khác ra công đào sâu thêm hố cách ngăn giữa người và thú vật. Tiêu chuẩn duy nhất để đánh giá thiên nhiên sống động là lí trí và trí hiểu của con người, là khả năng suy nghĩ và luận định của nó. Và họ đều cho rằng, cái phần cơ thể thuần tuý vật chất bên ngoài là điều không quan trọng.  

		Và để bảo đảm cho khả năng nhận định đúng đắn của con người, các triết gia đã phải chấp nhận rằng, Thượng đế đã ban cho con người một bộ máy nhận thức đặc biệt. Và với sự trợ giúp của ngài, con người có thể đọc được sự thật về thế giới từ „Cuốn sách thiên nhiên“. Nhưng nếu quả thật Thượng đế đã chết, thì bộ máy nhận thức được ban tặng kia hẳn chỉ có khả năng giới hạn. Và như thế, bộ máy này cũng chỉ là một sản phẩm của thiên nhiên, và cũng như mọi sản phẩm thiên nhiên khác, nó chẳng toàn hảo. Chính quan điểm này Nietzsche đã đọc được của Arthur Schopenhauer: „Chúng ta chung quy chỉ là một thực thể giai đoạn, hữu hạn, chóng qua, như một giấc mơ, như chiếc bóng bay qua“. Và như vậy con người làm sao có được một „trí khôn có thể nắm bắt được những cái đời đời, vô tận, tuyệt đối?“ Khả năng nhận thức của con người, như qua linh cảm của Schopenhauer và Nietzsche, trực tiếp lệ thuộc vào những đòi hỏi của tiến trình thích ứng tiến hoá. Con người chỉ có thể nhận biết được điều mà bộ máy nhận thức của nó, vốn được hình thành qua cuộc đấu tranh sinh tồn, cho phép nó hiểu mà thôi. Như bất cứ mọi loài thú khác, con người đổ khuôn thế giới theo các giác quan và nhận thức của mình. điều này hẳn rõ: Mọi nhận thức của chúng ta tuỳ thuộc trước hết vào các giác quan của chúng ta. Những gì không thể thấy, nghe, cảm, nếm và sờ, ta không nhận biết được chúng và chúng cũng không có mặt trong thế giới của chúng ta. Ngay cả những gì trừu tượng nhất, chúng ta cũng phải tìm cách đọc hay có thể nhìn chúng như là những dấu chỉ, thì mới hình dung ra được chúng. Như vậy, để có thể có được một vũ trụ quan hoàn toàn khách quan, con người hẳn phải cần có một bộ máy nhận thức siêu nhân có thể nắm bắt được hết mọi góc cạnh của giác quan: cặp mắt siêu đẳng của đại bàng, khứu giác ngửi xa nhiều cây số của loài gấu, hệ thống đường hông của cá, khả năng biết được động đất của rắn v.v. Nhưng con người không thể có được những thứ đó, và vì thế nó không thể có được cái nhìn khách quan toàn bộ của các sự kiện. Thế giới của chúng ta chẳng bao giờ là cái thế giới như „vốn có của nó“, nó cũng chỉ là cái thế giới của con chó con mèo, của con chim con bọ, không hơn không kém. „Con ơi, thế giới của ta là một cái thùng lớn đầy nước!“, đó là câu giải thích của cá bố cho cá con trong chậu.  

		Cái nhìn không nhân nhượng của Nietzsche về triết học và tôn giáo cho thấy sự ôm đồm bao biện của con người qua những tự định nghĩa của họ (Còn việc chính Nietzsche đặt ra cho thế giới những ôm đồm bao biện mới, thì đây lại là chuyện khác). Í thức con người không nhắm ưu tiên tới câu hỏi: „đâu là sự thật?“. đối với họ, câu hỏi sau đây quan trọng hơn: đâu là điều tốt nhất cho sự sống còn và thành đạt của tôi? Những gì không liên quan trực tiếp tới vấn nạn này xem ra ít có cơ hội có được một vai trò quan trọng trong cuộc tiến hoá loài người. Nietzsche mơ hồ hi vọng rằng, có lẽ sự tự nhận thức của con người ngày càng trở nên sáng suốt hơn, nó có thể tạo cho họ trở thành một „siêu nhân“ và „siêu nhân“ này hẳn sẽ có được khả năng nhận thức lớn hơn. Nhưng điểm này cũng nên cẩn thận. Là vì cho dù những tiến bộ nhân loại đã đạt được cho tới nay trong việc tìm hiểu về nhận thức và về „hoá học“ của con người, kể cả việc có được những máy móc tinh vi nhất và những quan sát bén nhạy nhất trong địa hạt này, chúng ta vẫn phải thú nhận rằng, con người không có khả năng đạt tới được một nhận thức khách quan.  

		Nhưng điều đó chẳng có hại gì lắm. Có lẽ còn nguy hiểm hơn nhiều, nếu như con người thông suốt được mọi sự về chính mình. Chúng ta có nhất thiết cần đến một chân lí độc lập bay lơ lửng trên đầu chúng ta không? Nhiều khi chính con đường đi cũng là một mục tiêu đẹp rồi, nhất là khi con đường đó lại là lối dẫn vào trong chính ta, lối đi chằng chịt nhưng cũng đầy hấp dẫn. „Chúng ta chưa bao giờ tìm hiểu mình – chuyện gì sẽ xẩy ra, nếu một ngày nào đó ta nhận ra ta?“, đó là câu hỏi Nietzsche đã nêu lên trong Genealogie der Moral. Vì thế, giờ đây chúng ta hãy cố gắng tìm hiểu mình, được chừng nào càng tốt. Nhưng ta sẽ dùng con đường nào, sẽ chọn cách thức nào để thực hiện? Và rồi ra kết quả sẽ ra sao? Nếu mọi nhận thức của chúng ta đều diễn ra trong não bộ và bị lệ thuộ c vào não bộ của loài vật có xương sống, thì tốt nhất ta hãy bắt đầu bằng tìm hiểu ngay não bộ. Và câu hỏi đầu tiên sẽ là: Não bộ đến từ đâu? Và tại sao nó có được cấu trúc như nó hiện có?  

		•Lucy ở trên trời. Chúng ta đến từ đâu?'
		),
		('MS002','MC002',N'Lucy ở trên trời Chúng ta đến từ đâu?',N'đây là câu chuyện của ba câu chuyện. Câu chuyện thứ nhất như sau: Ngày 28 tháng 2 năm 1967 – Hoa-kì đội bom xuống Bắc Việt Nam; ở Berlin (Tây đức) nổi lên những cuộc chống đối đầu tiên của sinh viên, công xã thứ nhất (của nhóm thanh niên sinh viên thế hệ 68 sống chung chạ với nhau. Người dịch) vừa được hình thành; Che Guevara bắt đầu khởi sự cuộc chiến du kính trên cao nguyên miền trung nước Bolivia; và John Lennon, George Harrison và Ringo Starr cùng nhau lập phòng thu băng nhạc ở đường Abbey trong thủ đô London. Một trong những dĩa nhạc thu băng của họ mang tên Sgt. Peppers’s Lonely Hearts Club Band, và một bài hát trong đó có tên Lucy in the Sky with Diamonds. Vì cái tên lạ và lời lẽ siêu thực của bài hát, nhiều người mê nhạc Beatle tới ngày nay vẫn tin rằng, John Lennon sáng tác bài này trong cơn say và bài hát đó là một lời ngợi ca ma tuý. Nhưng sự thật không phải thế, nó khá đơn giản và cảm động. Lucy không phải là ai khác ngoài người bạn gái cùng lớp của Julian Lennon, con của John Lennon. Cậu bé Julian đã tự vẽ cô bạn này và đưa cho ông bố xem bức hoạ mang tên “Lucy in the Sky with Diamonds” của mình.   

		Và như vậy tiếp theo câu chuyện thứ hai. Năm 1973: Donald Carl Johanson, lúc đó chưa đầy 30 tuổi, đi theo một đoàn thám hiểm tới vùng cao nguyên đầy gió bụi gần thành phố Hadar của Ethiopia. Johnanson miễn cưỡng muốn trở thành một nhà chuyên môn về răng các loài vượn. Từ ba năm nay, anh đang viết luận án về răng vượn; anh đã tìm hiểu bao nhiêu là sọ vượn trong tất cả các viện bảo tàng ở Âu châu, và lúc này anh chẳng còn hứng thú gì nữa về đề tài này. Nhưng nhiều đồng nghiệp nổi tiếng người Pháp và Hoa-kì lại rất cần một người biết nhiều về răng vượn như anh. Ai muốn nghiên cứu về xương người hoá thạch, tất phải cần tới một chuyên viên về răng. Vì răng thường là những cổ vật ít bị hư hao nhất trong các cổ vật tìm thấy, và răng người với răng vượn không khác gì nhau. Riêng Johanson thì rất mừng được theo đoàn nghiên cứu, vì con đường tiến thân bằng nghiên cứu khoa học quả là một cơ hội mới mẻ đối với anh. Johanson xuất thân từ Hartford bang Connecticut, là con trai của một người Thụy-điền di cư sang Hoa-kì. Cha mất sớm, khi cậu Don mới hai tuổi, vì thế Don phải trải qua một thời niên thiếu rất khó khăn. Một nhà nhân chủng hàng xóm đã bảo trợ cậu như một đứa con nuôi, giúp ăn học và đánh thức dậy sở thích cổ sử nơi cậu. Johanson sau đó đã học Nhân chủng học và bước theo vết chân của người bảo trợ mình. Chính cậu sẽ là người để lại cho nhân loại một cái gì đó lớn lao. Nhưng đó là chuyện tương lai. Còn lúc này đây, ngồi bới đất đá tìm xương người ở vùng tam giác Afar gần bờ sông Awash dưới ánh mặt trời như thiêu như đốt, chàng trai tóc đen, cao lêu nghêu và gầy trơ xương sườn Don đã chẳng nghĩ được gì hơn. Tình cờ anh gặp được một vài mẫu xương lạ: phần trên của một xương ống quyển và phần dưới của một xương đùi. Hai mẫu xương này ăn khớp với nhau lạ lùng. Johanson xác định đó là xương đầu gối của một loài vượn đi bằng hai chân, cao cỡ 90 phân, sống cách đây khoảng hơn ba triệu năm. Một phát hiện động trời! Là vì chuyện cách đây ba triệu năm đã xuất hiện một động vật đứng thẳng như người là điều tới lúc đó chưa ai biết hoặc nghĩ tới. Ai có thể tin được điều của một chuyên viên răng vượn hãy còn vô danh như cậu? Cậu chỉ còn một cách mà thôi: phải làm sao tìm cho được toàn bộ xương! Thời gian trôi qua, và một năm sau đó, ngày 24 tháng 11 năm 1974, Johanson trở lại vùng tam giác Afar cùng với Tom Gray, một sinh viên người Hoa-kì. Trước khi bước vào trại khảo cổ, hai người làm một vòng quan sát hiện trường. Tình cờ anh nhận ra một mẫu xương cánh tay nằm giữa đá lở. Rải rác quanh đó có nhiều mẫu xương khác: những đoạn xương bàn tay, xương sườn, các đốt xương sống, những mảnh xương sọ: những thành phần của một bộ xương tiền sử.  

		Và nối tiếp sau đây là câu chuyện thứ ba – câu chuyện về một người đàn bà nhỏ con, từng sống trên một miền đất mà ngày nay gọi là Ethiopia. Chị đứng thẳng khi bước đi, đôi tay tuy ngắn hơn tay của một người trưởng thành thời nay, nhưng có hình dạng giống in đúc xương tay người hiện đại. Người đàn bà thuộc loại lùn, nhưng bạn bè giới nam của cô cũng không lớn lắm, có lẽ chỉ cao vào khoảng 1,4 mét. Với thân hình như thế, cô rất khoẻ. Cô có những đốt xương vững, đôi tay tương đối dài. Chiếc đầu không lớn như của một người thường, mà chỉ bằng đầu của một chú vượn người. Xương hàm của cô bạnh ra và sọ trán phẳng. Có lẽ lông tóc cô màu đen, như các loài vượn người khác ở Phi châu, nhưng điểm này không chắc lắm. Cũng không biết được cô khôn lanh tới mức nào. Não bộ của cô lớn bằng não của một chú vượn, và cũng chẳng ai biết cô đã suy nghĩ được những gì. Cô chết lúc 20 tuổi, không hiểu vì nguyên nhân gì. 3,18 triệu năm sau đó, hồ sơ “AL 288-1” được xem là bộ xương đầy đủ và xưa nhất của một động vật giống như người. Cô thuộc chủng Australopithecus afarensis. Australopithecus có nghĩa “Khỉ miền nam”, và afarensis là tên của địa điểm nơi tìm thấy cổ vật: vùng tam giác Afar.   

		Hai nhà nghiên cứu nhảy lên xe, tống hết ga chạy về lều. Chưa tới trại, Gray đã la lớn:  

		“Chúng tôi đã có được nó rồi, chúng tôi đã có được hoàn toàn đầy đủ!” Phấn chấn cực độ. Johanson nhớ lại: “đêm đầu, chúng tôi không tài nào chợp mắt được. Chúng tôi chuyện trò không dứt và uống với nhau hết chai bia này tới chai khác”. Họ hát, họ nhảy. Và đây là điểm nối kết câu chuyện thứ nhất với câu chuyện thứ hai và câu chuyện thứ ba: Suốt đêm hôm đó bản nhạc Lucy in the Sky with Diamonds được phát đi phát lại vang dội ở một góc bầu trời đêm xứ Ethiopia. Và rồi, không biết chính xác từ giây phút nào, sau đó bộ xương đầy đặn 40% kia chỉ còn được gọi là „Lucy”. Và Lucy O’Donnel, người bạn gái cùng lớp của Julian Lemmon, cũng có lí do để vui mừng. Tên em giờ đây được lấy để làm bảo chứng cho một bộ xương có một không hai và cổ xưa nhất trong toàn bộ cổ sử và nguyên sử thế giới.  

		Lucy của Johanson chứng minh cho thấy „nôi loài người” nằm ở Phi châu, điều này trước đó người ta cũng đã mơ hồ tin như thế rồi. Lịch sử nguồn gốc loài người, bao lâu còn được hình dung như lịch sử phát triển của từng cá nhân, bấy lâu vẫn không xoá đi huyền thoại về tạo dựng. Nhưng hình ảnh về nôi sinh thành trên đây cũng đồng thời làm cho các nhà nghiên cứu hi vọng rằng, rồi đây họ sẽ xác định được biên giới giữa loài người và loài vật; không những xác định về địa điểm, mà cả về thời gian từ lúc con người bước ra khỏi Rãnh Gregory (Gregory-Spalte) miền đông Phi châu, bắt đầu đứng thẳng và biết sử dụng vũ khí đá đẽo, cho đến khi trở thành những kẻ săn bắn thú hoang biết nói năng trao đổi với nhau. Nhưng đây quả thật có phải là loài động vật đầu tiên và duy nhất biết đứng thẳng, biết sử dụng dụng cụ săn bắn các thú hoang lớn không? Cho đến lúc đó, vết tích cổ nhất mà người ta tìm được của một loài vượn người  

		(Hominoidea) có niên đại vào khoảng 30 triệu năm. Tuy nhiên, người ta hiện gần như chẳng biết chút gì thêm về loài vượn này. Là vì chỉ có được một vài mẫu xương hàm dưới không đầy đủ và hư hại nhiều, thế thôi, đó là tất cả những gì có được để các nhà khoa học đưa ra những kết luận của họ. Cả việc phân loại các loài vượn cổ sau này, người ta cũng như đang lần mò trong đêm tối. Chỉ khi rừng và đồng cỏ xuất hiện, khoa Cổ nhân chủng học mới có được một cái nhìn rõ hơn. Khoảng 15 triệu năm trước, các lực ép dữ dội trong lòng đất đã đẩy vỏ địa cầu phía đông châu Phi lên một độ cao gần 3000 mét cách mặt biển. Các tảng đá lục địa bị uốn cong, nứt thành một rãnh dài trên 4500 cây số, và từ khe rãnh đó xuất hiện một hệ thực vật hoàn toàn mới. Nhờ sự hình thành Rãnh Gregory và thung lũng (Great Rift Valley) trong đó mà các loài vượn – và từ đó loài người – cũng xuất hiện. Nhà cổ nhân chủng học nổi danh Richard Leakey phỏng đoán: „Nếu Rãnh Gregory đã không hình thành ở địa điểm đó và vào thời gian đó, thì loài người có lẽ cũng đã không xuất hiện“.  

		Phía tây Rãnh là những cánh rừng nguyên sinh với thức ăn phong phú, nơi sinh sống lí tưởng cho các loài linh trưởng. Phía đông, trái lại, là những bán sa mạc, những rừng cỏ nhỏ và đồng lầy sông lạch tạo ra do những cánh rừng chết. Cách đây độ bốn hay năm triệu năm, đây là đất sống lí tưởng cho một vài loài Hominid (vượn người), chẳng hạn như loài Australopithecus, là loài đầu tiên có thể đứng thẳng khi đi. Một vài loài trong số này đã biến mất vào một lúc nào đó, các loài khác vẫn tiếp tục sinh sôi phát triển. Cách đây khoảng ba triệu năm,  

		Australopithecus tách ra thành nhiều loài khác, mà nay ta biết khá rõ về chúng. Trong các loài mới này có Australopithecus robustus và Australopithecus africanus. Australopithecus robustus là loài có sẽ sống bằng thực vật với chiếc sọ vạm vỡ và những xương hàm rất lớn, loài này đã biến mất khoảng 1,2 triệu năm trước. Còn Australopithecus africanus có sọ nhẹ hơn và răng nhỏ hơn; nó được xem là gốc tổ của Homo habilis vốn là đại biểu đầu tiên của gia đình Hominae (giống người), nhưng loài này còn được phân ra ít nhất thành hai loài nữa, mà ngày nay ta hoàn toàn không biết gì về mối dây bà con giữa chúng.  

		Sọ của các Australopithecinen đúng là sọ khỉ. Cũng giống như các loài linh trưởng khác, cặp mắt của chúng nằm dôi ra phía trước sọ, điều này có nghĩa, loài khỉ luôn chỉ nhìn được một phía. Muốn mở rộng tầm nhìn, chúng phải quay đầu. Một hệ quả của tình trạng này là khỉ có lẽ mỗi lúc chỉ có được một tình trạng í thức mà thôi. Vì chúng không thể nhận thức được nhiều chuyện trong cùng một lúc, nên những sự vật chỉ tiếp theo nhau hiện lên trong í thức. Góc nhìn hạn chế như vậy là điểm hoạ hiếm nơi các loài có vú; ở những giống vật khác như ruồi hay bạch tuộc thì tầm nhìn của chúng vô cùng lớn. Còn về khả năng thị lực, mọi loài khỉ đều nằm ở độ trung bình. Khả năng thấy của chúng khá hơn ngựa hay tê giác, nhưng lại thua rất xa các loài chim ưng. Cũng giống như hầu hết các loài thú có xương sống, nơi vượn hay khỉ có sự phân biệt hai vùng nhận thức trái và phải. Quan niệm „trái“ và „phải“ ảnh hưởng trên kinh nghiệm về thế giới và cả trên lối nghĩ của chúng. Các loài sứa, sao biển và nhím biển không có sự phân biệt phải hay trái đó, vì óc của chúng mang dạng hình tròn. Các loài khỉ cũng không cảm được những biến đổi của giòng điện, khác hẳn với nhiều loài thú khác, đặc biệt nơi cá mập. Khứu giác của khỉ rất dở, thua xa chó, gấu và nhiều loại côn trùng. Khả năng nghe của chúng khá tốt, nhưng cũng không bì được với chó, với gấu.  

		Diễn tiến lạ lùng nào đã xẩy ra nơi vài ba loài vượn cách đây độ ba triệu năm, điều này khoa học vẫn chưa biết được. Chỉ trong một thời gian tương đối ngắn đó, não của chúng đã lớn lên gấp ba lần. Australopithecus có khối lượng óc từ 400 tới 550 gram; óc của Homo habilis cách đây khoảng hai triệu năm nặng từ 500 tới 700 gram; Loài Homo heidelbergensis và Homo erectus xuất hiện cách đây độ 1,8 triệu năm có khối óc từ 800 đến 1000 gram. Và khối óc của loài người tân tiến Homo sapiens, xuất hiện cách đây khoảng 400 000 năm, cân được từ 1100 tới 1800 gram.  

		Các nhà khoa học trước đây giải thích, khối lượng óc gia tăng chính là do việc thích ứng với môi trường sống. Môi trường sống trong thảo nguyên của Rift Valley hoàn toàn khác với hoàn cảnh sống trong các rừng già trước đó, và các Australopithecinen cũng như các giống Homo cổ đã phải thích ứng với các môi trường sống mới. điều này đúng. Nhưng việc gia tăng quá nhanh độ lớn của óc do hậu quả điều kiện sinh môi thay đổi là chuyện chẳng bình thường gì cả, nó phải được coi là một biến cố hoàn toàn bất thường. Các loài thú phải thích ứng với sinh môi, dĩ nhiên. Chúng biến đổi, lớn thêm hay nhỏ lại, nhưng óc của chúng không thể phình lớn nhanh như thế được. Linh trưởng trong vùng thảo nguyên hiện nay cũng chẳng khôn gì hơn linh trưởng trong các rừng già. Nhưng khối óc của các giống vượn người cổ gia tăng quá nhanh cách lạ thường, còn nhanh hơn tầm lớn của thân xác chúng – điểm này cho đến nay mới chỉ thấy được nơi loài người và loài cá heo mà thôi.  

		Chúng ta biết được tiến trình phát triển đặc biệt của óc người là nhờ công trình riêng biệt của hai tác giả người Pháp là Emile Deveaux và người Hoà-lan là Louis Bolk trong những năm 1920’. Theo hai vị này, con người khi lọt lòng mẹ vẫn chưa phát triển đầy đặn, trong khi đó các loài vượn người khi sinh ra thì đã phát triển gần như đầy đủ rồi. Thời gian phôi thai nơi con người dài hơn và trong thời gian đó con người đã có khả năng học tập. Khoa nghiên cứu não ngày nay đã có thể xác nhận điểm này. Trong khi óc của mọi loài có vú khác sau khi sanh lớn chậm hơn thể xác, óc con người từ thời phôi thai cho tới một thời gian dài sau khi sanh vẫn tiếp tục phát triển với vận tốc ngang bằng vận tốc phát triển của thể xác. Bằng cách đó, óc người đã có được một độ lớn vượt lên trên các loại vượn người khác. đặc biệt tiểu não và vỏ đại não đã có được nhiều lợi điểm trong sự phát triển này. Và trong đại não, đặc biệt những vùng liên quan tới khả năng định hướng, khả năng âm nhạc và khả năng tập trung là quan trọng nhất.  

		đó là những gì ngày nay ta biết được nơi tiến trình phát triển não. Nhưng tại sao, khoảng 

		ba triệu năm trước, nó lại xẩy ra như thế? Không rõ. Chúng ta càng biết chính xác về diễn tiến bao nhiêu, thì lại càng mơ hồ về lí do của diễn tiến đó bấy nhiêu. Là vì chỉ nhu cầu thích ứng mà thôi thì không đủ để giải thích sự tăng trọng quá nhanh của não, cho dù ta có đủ lí do để bảo rằng, hoàn cảnh sống mới nơi thảo nguyên đòi hỏi phải có một thích ứng lớn. đúng, khả năng đứng hai chân làm thay đổi cung cách chạy trốn. đúng, đời sống gia đình nơi thảo nguyên không giống như trong rừng già. đúng, nơi thảo nguyên phải có cách săn tìm những thức ăn mới. Nhưng tất cả những cái đó cũng không cắt nghĩa được độ lớn gấp ba của não. Não con người quá phức tạp, nó không chỉ lớn lên vì hoàn cảnh sinh môi mà thôi. Nhà nghiên cứu não ở Bremen, Gerhard Roth, viết: „Không phải hoàn cảnh sống đã buộc con người phải có một vỏ não (Cortex) hay một vỏ não trước lớn. Những thứ này con người có được là do trao tặng một cách ‘nhưng không’ “.   

		Như vậy, sự phát triển của não người không chỉ do ảnh hưởng của các điều kiện môi sinh. Nếu trong chương đầu có nói, bộ não của loài vật có xương sống chúng ta là kết quả của sự thích ứng với tiến trình tiến hoá, thì ta phải thú nhận rằng, chúng ta vẫn chưa biết gì chính xác về những mối liên hệ này. Có thể nói, cho tới lúc này chúng ta chẳng biết lí do nào đã đưa đến sự „tối ưu hoá“ này. Và suốt một thời gian rất dài, cha ông chúng ta đã ít sử dụng hết khả năng của bộ não vốn lớn nhanh trong đầu. Từ Australopithecus tới Homo habilis và Homo erctus não đã lớn với tốc độ kinh hoàng, nhưng cuộc sống văn hoá đã không có gì thay đổi, chẳng hạn như chẳng có được những cải tiến trong việc chế biến hay sử dụng những dụng cụ. Ngay cả lúc não đã gần như phát triển tương đối xong vào khoảng một triệu năm trước đây, cha ông Hominiden của chúng ta trong suốt nhiều trăm ngàn năm cũng đã không sáng chế ra được gì hơn ngoài mấy miếng đá đẽo nhọn thô sơ. Những dụng cụ của người Neandertaler, một chủng loại đã biến mất cách đây trên dưới 40 000 năm, cũng thô sơ và ít được mài bén. Nên biết rằng, khối lượng bộ não của chủng Neanthaler còn lớn hơn não của người thời nay!  

		Trong tiến trình phát triển của loài người tân tiến với nền văn hoá có một không hai của họ, não giữ vai trò quyết định, điều này đã rõ. Nhưng tại sao con người đã sử dụng khả năng cải tiến kĩ thuật của mình quá trễ đến như thế? Câu trả lời có thể là: Vai trò của não không phải để cải tiến kĩ thuật, nhưng nó mang những nhiệm vụ nào đó khác hơn. Cũng như các vượn người ngày nay tuy khôn ngoan hơn, nhưng vẫn chỉ biết bẻ cành ném đá, chỉ biết sử dụng các dụng cụ một cách thô thiển như thời các Australopithecinen trước kia. Vượn người dùng phần lớn trí khôn của chúng cho cuộc sống xã hội phức tạp; và nơi con người cũng thế, đồng loại là thách đố lớn nhất trong cuộc sống hàng ngày của họ (Xem bài Cây kiếm của người giết rồng). Chúng ta chỉ sử dụng một phần rất nhỏ khả năng của mình, bởi vì Trí tuệ là thứ chúng ta chỉ cần lúc chúng ta gặp bí mà thôi. Ngay cả nếu những nhà nghiên cứu vượn lấy ống nhòm mà quan sát Albert Einstein, như họ ngày nay quan sát các chú khỉ, thì họ cũng chẳng nhận ra gì đặc biệt nơi ông. Trong cuộc sống thường ngày với ngủ, thức, ăn, uống, bận áo quần v.v. Einstein chẳng cần gì tới bộ óc thiên tài của mình, bởi vì những sinh hoạt đó chẳng đòi hỏi tia chớp sáng tạo nào cả.  

		Não con người là một bộ máy lạ lùng. Nhưng nó không phải là một bàn cờ vi tính, luôn phải động não để tìm những nước cờ hiểm yếu. Thường thì bộ máy này chạy ở mức thấp, và như vậy thì loài người ngày nay cũng không khác gì cha ông họ từ thủa hồn hoang. Con người ngày nay cũng không khác khỉ về những bản năng nền tảng và về cung cách gây chiến và xâm lược, về những gì thuộc phản xạ, về tình cảm gia đình và cộng đoàn. Càng biết về đời sống các thú vật, chúng ta càng rõ hơn về chính mình vốn là âm ba của 250 triệu năm tiến hoá của loài vật có vú vọng lên từ não của ta.  

		Như vậy, loài thú tinh khôn của Nietzsche đúng là những thú vật, và khả năng nhận thức có một không hai của chúng trước sau vẫn là một ẩn số. Một vài triết gia thời Lãng mạn đầu thế kỉ 19 cho rằng, thiên nhiên vận hành không phải vô định, nhưng có mục đích, và mục đích cuối cùng của nó là sự hình thành loài người – và chủng loại người được hình thành nên là để giải mật sự vận hành của thiên nhiên. Các vị đó đã hiên ngang bảo rằng, thiên nhiên sẽ tự bạch hoá mình ra nơi con người. Nhưng thực tế chẳng có gì minh chứng cho lập luận: con người và hành vi của họ là cùng đích hành trình của thiên nhiên cả. Không những chuyện vận hành của thiên nhiên, mà ngay cả khái niệm „mục đích“ cũng đáng ngờ. Mục đích là một phạm trù tư duy rất mang tính người (loài tắc kè có mục đích không?), nó đặc biệt gắn liền với các quan niệm của con người về thời gian, cũng giống như các khái niệm „tiến bộ“ và „í nghĩa“. Nhưng thiên nhiên là chuyện của vật lí, hoá học và sinh vật. Và khái niệm „í nghĩa“ mang những tính chất hoàn toàn khác với Prôtêin, chẳng hạn.   

		Những cô cậu tinh khôn nhất trong đám thú của Nietzsche đã hiểu ra được điều đó, nên họ không còn mơ làm chuyện ôm đồm to lớn là đạt tới sự „khách quan“ của thực tại nữa. Song giờ đây họ tự hỏi: đâu là điều tôi có thể hiểu được? Và cái hiểu đó cũng như cái có thể hiểu đó hoạt động ra sao? Các triết gia cho rằng, đây là một „chuyển hướng tri thức“ đưa tới những nền tảng cho việc tìm hiểu về chính mình và về thế giới. để hiểu điều này, tôi muốn dẫn quý vị hành trình vào các nền tảng của bộ máy nhận thức của chúng ta, những nền tảng mà chúng ta đã chia sẻ với nhau một số điểm quan trọng qua câu chuyện Lucy trên đây rồi. Chúng ta hãy cùng Lucy bay vào một vũ trụ còn hào hứng hơn tất cả những vũ trụ mà các triết gia trước đây đã bay vào. Chúng ta hãy khám phá Cảm giác và Tư duy của chúng ta, bằng cách hành trình vào trong não bộ của chúng ta.  

		•Vũ trụ Tinh thần. Não của tôi hoạt động như thế nào?')
go

insert into NOIDUNGSACH values 
	('MS003', 'MC001', N'Miriam Winters', N'Đọc lướt xong bức thư sau cùng, tôi lơ đãng bóc một bức thư mà người thư ký của tôi để nguyên chưa mở. Có lẽ cô ấy nghĩ đây là thư riêng nên để nguyên niêm. Không biết đầu óc để ở đâu, tôi quên không coi địa chỉ người gởi, vì thế nội dung bức thư làm tôi giật mình.

	“Vì chúng tôi không tìm thấy người bà con nào, trong khi dường như ông là người liên lạc thư từ và là khách thăm duy nhất của bà ấy nên chúng tôi xin báo cho ông biết là bà Miriam Winters đã qua đời. Bà ấy chết thanh thản trong giấc ngủ vào ngày 25 vừa qua”.

	Ánh nắng đang chiếu qua mành cửa sổ văn phòng tôi bỗng trở nên lạnh lẽo. Tôi đang đứng khi mở bức thư, bây giờ, tôi đã ngồi xuống, xoay cái ghế bọc da một vòng, nhìn đăm đăm ra cửa sổ. Thế là, sau cùng, bà ấy đã chết. “Khách thăm duy nhất”. Lạy Chúa, không hẳn thế ! Lần sau cùng gặp bà ấy là khi nào nhỉ ? Năm năm ? Sáu năm ? Tôi nhớ có nhận được một thiệp mừng Giáng sinh và bà ấy cứ nhắc đi nhắc lại là tôi phải viết thư cho bà ấy. Bà ấy cô đơn, cô đơn ghê gớm vào những năm cuối cùng trong đời, ắt hẳn thế. Lòng tôi bỗng tràn ngập một nỗi ân hận, thứ cảm giác mà bạn thấy khi một người đã chết mà chưa thu xếp xong những việc còn dang dở.

	Tôi chỉ là một thằng nhóc mười sáu tuổi khi họ thả ông Winters và vì thế, tôi có trách nhiệm về việc giải cứu ông ta. Tôi đi lăng quăng mùa thu năm đó, vênh váo như một anh hùng đáng nguyền rủa. Tôi không ý thức được sự lố bịch của mình cho đến sau này. Tôi không trở lại Wilton Falls nhiều năm qua và tôi không biết họ có còn kể cho con cháu họ nghe chuyện xảy ra mùa thu năm ấy hay không. Tôi không biết họ vẫn cứ kể lại câu chuyện theo cách đó – Tạo ra một huyền thoại Miriam – Mụ phù thủy ? Vâng, họ lầm. Bà ấy không phải là phù thủy. Tôi đã được nghe bà ấy kể lại hết.

	Xoay cái ghế bọc lại bàn giấy, tôi nhìn bức thư một lần nữa. Thật kỳ lạ ! Nhưng có thể tôi là người còn sống duy nhất đã nghe tất cả câu chuyện kể lại bởi chính bà ấy. Chắc chắn báo chí không cho bà ấy có cái quyền đó. Chắc chắn báo chí không bao giờ cho bà ấy có được dịp kể lại tất cả sự việc. Họ quá mê mải viết những bài giật gân về sự khủng khiếp bà ấy đã gây ra.

	Quả thật, đó là một chuyện khủng khiếp.

	Tôi không bao giờ chối bỏ điều đó. Tôi cũng không tha thứ việc bà ấy đã làm. Nhưng định mệnh đã đưa vào tay tôi trọn vẹn tấn bi kịch mà không ai có được. Vì thế, tôi luôn luôn nghĩ khác về Miriam Winters.'),
	
	('MS003', 'MC002', N'Quá khứ', N'Miriam ngừng lại để lau mồ hôi trên trán nàng. Chỉ còn hai cái áo sơ mi chưa ủi. Harry sẽ về nhà tối nay và hắn sẽ hỏi chúng trước tiên. Hắn ta có rất nhiều áo sơ mi đủ để thay trong một tháng xa nhà trong khi ở nhà hắn cũng còn ngần ấy áo cho Miriam giặt ủi. Một người bán hàng phải ăn mặc chải chuốt, Harry luôn nói thế. Mà hình như hắn thay áo nhiều hơn cần thiết. Sau lần sai lầm ngớ ngẩn đầu tiên, nàng không bao giờ nhắc lại chuyện đó khi thấy vết son môi, vết phấn vấy bẩn trên áo hắn.

	Nàng nhìn đồng hồ phía trên lavabo một cách sợ hãi. Tại sao nàng phải để đến giờ chót ? ồ, vì tháng này nhiều chuyện quá. Bobby ốm rồi đến lượt nàng, nàng bị chứng nhức đầu ghê gớm hành hạ liên miên. Từ khi Harry đánh nàng té vào lò bếp thì nàng bị chứng nhức đầu đó và một thứ cảm giác kỳ lạ chiếm ngự trí não nàng luôn luôn. Nàng đặt bàn ủi xuống, lấy tay day day trán. Nàng không sợ nhức đầu lắm nhưng cái cảm giác kỳ cục kia

	… nàng tự hỏi không biết có phải mình bị mất trí nhớ từng lúc hay không. Nàng mong rằng chuyện đó không có. Bobby tuy còn bé nhưng đã có thể tự lo cho mình ăn uống, tắm rửa … nhưng nó sẽ làm gì được một khi mẹ nó bị mất trí nhớ một ngày nào đó ?

	May thay, nàng vừa ủi xong cái áo cuối cùng thì xe hơi của Harry lái vào bãi cỏ sau nhà. Hắn tông cửa bước vào. Hắn lớn hơn Miriam hai mươi tuổi, to con.Hắn đặt túi hành lý xuống đất không đáp lại lời chào ” … Hello!” run rẩy của Miriam. Hắn quay ra rồi trở vào với hai túi giấy mà hắn cẩn thận đặt trên bàn làm bếp. Tim Miriam chùng xuống. Thế có nghĩa là hắn không vui rồi. Nàng luôn luôn biết điều đó bởi những chai rượu hắn đem về để uống trong vài ngày nghỉ ngắn ngủi ở nhà trước khi lên đường.

	– Em chuẩn bị bữa ăn cho anh rồi đấy!

	Vừa nói, Miriam vừa chỉ vào bếp.

	Đang lúi húi mở những nắp chai rượu, Harry dừng lại liếc nhìn nàng rồi lại cắm cúi vào những chai rượu.

	– áo của tôi xong chưa ? – Vâng … xong cả rồi … tất cả. Anh ngồi vào bàn đi, em dọn cho anh ăn. Hắn lầm bầm trong miệng rồi ngồi vào bàn.

	Hai giờ sau, hắn đã say mèm.

	Hắn không cho nàng đi ngủ.

	Tuy nàng tránh được những cái vồ của hắn trong cơn say bí tỉ nhưng sau cùng hắn cũng dồn được nàng vào góc nhà. Hơi thở hắn nồng nặc mùi rượu. Bàn tay hắn lần mò trên thân thể nàng khiến nàng buồn nôn.

	– Đừng … đừng … Harry …

	Giọng nàng vô tình cất cao trong hơi thở gấp. Có những bàn tay khác chụp lấy tay nàng. Đó là Bobby. Giật mình vì tiếng kêu của nàng, nó vừa khóc vừa chạy vào bếp.

	– Mẹ ơi ! Mẹ ơi !

	Nó la lên, cố kéo nàng thoát khỏi tay gã đàn ông đang say. Miriam nuốt nước mắt, cố gắng nói bằng giọng ôn hòa :

	– Con phải trở lại phòng và ngủ đi, Bobby … nào … để mẹ đưa con đi ngủ … Nhưng Harry ôm chặt nàng :

	– Cô không được đi đâu cả … dẹp cái trò làm mẹ bẩn thỉu đó đi một lát đã … khi một người đàn ông đi xa về thì hắn cần giải trí … giải trí kiểu vợ chồng …

	Hắn quay sang đứa bé. Nó vẫn bám chặt mẹ nó.

	– Cút ngay ! Đồ khốn nạn ! Đi ngủ !

	Nhưng thằng bé khốn khổ không nghe hắn.

	Nhanh như chớp, hắn vung bàn tay hộ pháp.

	Thân hình thằng bé hình như bay trong không khí. Đúng, nó bay trong không khí trước khi nằm một đống dưới lavabo. Một vết tét ngay trên trán thằng bé, máu xịt ra có vòi rồi tuôn xối xả thành dòng đầy mặt nó. Miệng nó mấp máy nhưng không phát ra tiếng nào.

	Ngay cả Harry cũng bàng hoàng trước cảnh tượng đó. Hắn không ngăn cản Miriam khi nàng vùng khỏi tay hắn cùng với tiếng thét hãi hùng. Thằng bé vẫn thở. Tiếng khóc thảm thiết của nó hòa lẫn tiếng khóc đau lòng của mẹ nó. Nàng ôm nó vào lòng, dỗ dành. Nàng thấm mặt nó bằng một cái khăn ướt. Chẳng hi vọng gì ở sự giúp đỡ bên ngoài vào lúc nguy cấp này vì nhà không có điện thoại mà Harry thì quá say không thể lái xe được. Căn nhà lại ở một nơi biệt lập, nằm ngay rìa một cánh đồng cỏ. Bên kia cánh đồng cỏ là một khu rừng nhỏ. Người láng giềng gần nhất thì ở cách đây hai cây số.

	Sau cùng, tạ ơn Trời, dòng máu yếu dần rồi ngừng hẳn. Miriam nhẹ nhàng lau sạch máu trên mặt con trai nàng. Vết tét khá dài và nàng kinh hoảng khi thấy vết đứt gần sát bên một con mắt. Sáng mai nàng sẽ mời bác sĩ, còn bây giờ thì cho nó đi ngủ có lẽ là giải pháp hay nhất. Nàng bế thằng bé lên, đi ngang qua Harry. Hắn đã ngồi lại bàn, uống tiếp. Nàng băng cho nó vụng về rồi đặt thằng bé vẫn còn thút thít khóc lên giường. Nó không cho nàng đi nên nàng ngồi lại với nó cho đến khi tiếng nức nở lịm dần và thằng bé mau chóng rơi vào giấc ngủ say.

	Nàng nhẹ nhàng trở lại nhà bếp. Đầu hắn gối trên hai cánh tay khoanh lại đặt trên bàn. Miriam lay hắn, hắn không nhúc nhích. Nàng đến bên bàn để dao, mở ngăn kéo, chọn một con dao lớn nhất, sắc nhất. Đóng ngăn kéo lại, nàng đến cạnh chồng. Giơ cao con dao, cân nhắc, đắn đo … đâm hay chém ?

	Cách nào hay nhất đây ?

	Thật kỳ lạ ! Vận mạng nàng trên cõi đời này cho đến giờ phút này là của người đàn ông đang gục trên bàn. Nàng đã lầm lỡ với hắn. Nàng ghét hắn nhưng không biết làm thế nào để thoát khỏi tay hắn. Đó là nguyên nhân của một cái gì đó lạ lùng thình lình xui khiến nàng cho nàng biết nên làm cái gì. Nàng không kinh ngạc chút nào về sự quả quyết của mình, nàng cũng không muốn hỏi ý kiến ai. Harry phải chết, vậy thôi. Nàng biết chắc thế.

	Cái gì trong tay nàng vậy ?

	Một đoạn văn lạ lùng từ thuở thơ ấu ở trường học “Bạn đừng giết người nhé!” Phải chăng đó là sự nhận thức về cái khó là làm thế nào để thủ tiêu xác chết ? Có lẽ. Nhưng đúng hơn, có thể đó là ý nghĩ thình lình xẹt qua trong trí nàng, ý nghĩ rằng chính nàng đứng trước vành móng ngựa và Bobby cô đơn. Những kẻ sát nhân luôn luôn bị bắt mà ! Nàng chẳng có kế hoạch gì để che giấu “tội ác” của nàng. Nàng cũng chẳng có chút hi vọng nào là nàng sẽ qua mặt được nhà chức trách, nếu nàng giết người. Nàng không có được sự khôn ngoan đó, vậy thôi.

	Chậm chạp, nàng hạ con dao xuống.

	Có lẽ nàng không thể giết Harry, nhưng hắn phải bị kềm chế bằng cách nào đó chứ. Những gì vừa xảy ra tối nay … Miriam rùng mình khi nhớ lại khuôn mặt máu me của con. Không, con thú man rợ phải bị giết hay nhốt lại …

	Nhốt lại ? Nàng suy nghĩ trong một thoáng. Phải rồi. Đó là câu trả lời. Căn nhà có những khoảnh đất rộng có hàng rào Harry đã mua gần một năm nay của những người chăn nuôi. Thật sự, họ là những người nuôi chó. Trong hầm ngầm dưới lòng đất họ đã xây một khoảng để tránh những cơn lốc mạnh. Chỗ đó hình vuông, mỗi cạnh gần ba mét, có rào chắn phía trên. Cái “chuồng” này cũng dùng cho việc sinh sản của những con chó cái. Harry mà ở trong cái “chuồng” đó thì hắn không bao giờ có thể hành hạ mẹ con nàng nữa.

	Nàng nhìn đăm đăm Harry. Có lẽ nàng sẽ vô cùng ngạc nhiên khi nghĩ rằng nàng có thể kéo được thân xác nặng nề của hắn ra khỏi nhà bếp này, xuống hầm, đưa vào chuồng. Nhưng giờ đây, nàng chỉ nghĩ rằng nàng phải làm việc đó.

	Harry khẽ cựa mình một hai lần trong “cuộc hành trình gian khổ” đó. Tuy thế, hắn không tỉnh lại nổi trong cơn say chết người này của hắn. Khi đưa được người chồng say mèm vào trong cái chuồng đó, người nàng ướt đẫm mồ hôi. Trong chuồng có một tấm ván lát sàn, nên sàn chuồng cao hơn sàn nhà vài phân. Rõ ràng đã có những con chó ở đây. Miriam lên lầu lấy hai cái mền rồi trở xuống ném chúng trên sàn gỗ. Nàng đóng cửa chuồng lại. Có một ổ khóa lớn móc ở then cửa. Nàng bấm ổ khóa. Nàng không có chìa của nó mà cũng chẳng cần vì nàng không định mở nó ra nữa, mãi mãi …

	Vài ngày đầu sẽ là những ngày ồn ào ghê gớm, dĩ nhiên. May mắn là căn nhà quá biệt lập nên tiếng gào thét phẫn nộ của Harry sẽ không ai nghe. Miriam đưa Bobby đến bác sĩ sáng hôm sau. Người bác sĩ kinh ngạc hỏi tại sao nàng không đưa nó đến ngay sau khi vừa xảy ra chuyện. Ông ta còn hỏi tại sao nó bị như thế.

	– Nó té, đầu đập vào ống nước dưới lavabo tối qua. Tôi không thể bế nó đi bộ đến đây giữa đêm khuya. Chồng tôi vắng nhà.

	Miriam nói dối, tin rằng Bobby sẽ không bác bỏ câu chuyện của nàng. Thằng bé không nói gì. Nó là một đứa bé ngoan ngoãn, điềm tĩnh, có vẻ lớn trước tuổi.

	Khi hai người trở về nhà, họ nghe tiếng hét của Harry trong cơn giận cuồng điên. Bobby nép sát vào mẹ nó. Miriam ngồi xuống một cái ghế gần cửa rồi bế nó lên lòng.

	– Nghe đây con trai, chẳng có gì phải sợ hãi tiếng hét đó … nó chỉ là … Nàng ngưng một chút, một ý nghĩ chợt nảy trong đầu.

	– Con có nhớ những chuyện cổ tích mẹ con mình đọc tối hôm kia không ?

	– Nhớ …

	– Con có nhớ chàng hoàng tử bị biến thành con ếch không ?

	– Nhớ …

	– Tốt, cha con cũng thế. Ông ấy bị biến thành một con gấu, một con gấu to xấu xí. Mẹ cho rằng đó là vì ăn ở ác độc nên bị trừng phạt. Bây giờ ông ấy đang ở dưới hầm nên ông ấy không thể làm hại mẹ con mình nữa.

	Mắt Bobby tròn xoe.

	Một tiếng thét ghê hồn từ dưới hầm vọng lên ngay lúc đó làm thằng bé run rẩy. Nó lắp bắp.

	– Ông ấy … ông ấy … không thể ra … – Không. – Miriam đáp, giọng tin chắc – Chắc chắn không thể ra được, chỉ vài ngày thôi, ông ấy sẽ không la hét nữa.

	Nàng đặt thằng bé xuống đất và đứng dậy. Nàng nói : – Này Bobby, con không được kể cho BẤT CỨ AI về những chuyện này nghe chưa ? Nếu con kể, họ sẽ thả ông ấy ra đấy.

	Mắt thằng bé mở to, chứa đầy sự khủng khiếp. Miriam vuốt lại quần áo, vẻ mãn nguyện. Vậy là thằng bé sẽ không bao giờ kể cho ai.')

insert into NOIDUNGSACH values 
	('MS004', 'MC001', N'Phòng làm việc', N'Vừa thấy cha từ trong nhà bước ra sân sau, Nguyên vội ném quả banh về phía ông và kêu lớn:
	– Ba ơi! Chụp lấy nè ba!

	Ánh nắng mặt trời chói chang khiến ông Bình – cha của Nguyên – phải nheo mắt nhìn theo quả banh vừa rơi xuống bãi cỏ xanh mướt rồi nẩy tung lên vài lần trước khi lăn vào dưới dãy hàng rào sau nhà.

	Ông Bình lắc đầu bảo con:

	– Hôm nay ba không thể chơi với con được, ba bận lắm.

	Rồi ông quay ngoắt lại và nhảy một bước trở vào nhà.

	Nguyên vén mấy ngọn tóc loà xoà trước trán, cất cao giọng hỏi chị nó:

	– Ba làm gì kỳ vậy chị Thảo?

	Thảo từ nãy giờ đã chứng kiến mọi việc, từ tốn trả lời Nguyên:

	– Em đã biết rồi mà còn hỏi.

	Nói xong, Thảo chà xát hai bàn tay vào chiếc quần jean rồi đưa hai cánh tay lên trời như sẵn sàng bắt quả banh Nguyên sẽ ném cho nó:

	– Chị sẽ chơi một chút với Nguyên nhé!

	– Cũng được! – Nguyên trả lời bằng một giọng không lấy gì làm hứng thú lắm. Rồi nó chậm chạp tiến về dãy hàng rào để tìm quả banh.

	Trong đầu Thảo và Nguyên có vô vàn thắc mắc về thái độ của ông Bình trong thời gian gần đây. Trước kia Thảo thường phân bì với em vì ông Bình chỉ dành thời giờ cho thằng con trai, chơi banh với nó, chơi Nintendo với nó v.v. Nhưng bây giờ thì ông hoàn toàn không còn thời giờ cho những việc ấy nữa. Suốt ngày ông giam mình trong căn phòng biệt lập ở tầng dưới, rất hiếm khi ông nói chuyện với nó.

	Thảo cũng có một “tâm sự” buồn như Nguyên vì ba không gọi Thảo là Cô Công Chúa nữa. Tuy Thảo không thích được gọi như thế nhưng ít nhất đó cũng là một dấu hiệu ba còn nhớ đến nó …

	… Hai chị em chơi banh với nhau được một lúc, đến lượt Thảo ném banh cho Nguyên. Quả banh ném quá đà khiến Nguyên phải chạy theo để bắt nhưng nó đã bắt hụt và quả banh lăn đi xa. Hai tay chống nạnh, Nguyên giận dữ hét lên:

	– Chị ném banh kiểu gì vậy? Chị phải đi nhặt banh về!

	– Không, em phải đi nhặt nó mới đúng vì em chụp hụt nó!

	– Không, chị phải đi!

	– Nguyên, em đã 11 tuổi, đừng xử sự như đứa bé lên hai vậy chứ!

	– Còn chị thì như đứa bé lên một!

	Thảo thở dài nghĩ: “Dạo này cả nhà mình dễ nổi nóng quá! Mọi việc cũng do ba mà ra. Bầu không khí trong gia đình trở nên căng thẳng từ khi ba bắt đầu vùi đầu vào công việc với mấy loại thảo mộc và các bộ máy kỳ quái của ba. Ba chỉ rời căn phòng đó để lên nhà trên khi cần hít thở không khí một tí, nhưng không bao giờ ba lưu lại với mọi người quá hai phút. Chính mẹ cũng để ý đến điều ấy. Mẹ cảm thấy đầu óc căng thẳng nhưng bề ngoài mẹ vẫn làm như không có gì thay đổi. Thực sự thì mẹ rất lo lắng cho ba.”

	Thảo đi nhặt quả banh, ném cho Nguyên. Hai đứa tiếp tục ném qua ném lại trong im lặng được chừng 10 phút.

	– Nắng chói quá. Chị bắt đầu thấy nóng rồi. Thôi chúng ta vào nhà.

	Nguyên ném quả banh vào bức tường nhà để xe. Nó đến gần Thảo trêu ghẹo:

	– Chơi banh với ba thú vị hơn. Ba không bỏ cuộc nhanh như chị và ba ném banh cũng rất chính xác. Chị thì chơi như mấy đứa con gái ….

	Thảo gầm gừ trong cổ họng, nhẹ nhàng đẩy Nguyên ra … Bỗng Nguyên buột miệng hỏi:

	– Chị Thảo, tại sao ba bị sa thải không được làm việc ở Viện Đại Học nữa?

	Thảo nheo mắt, đứng dừng lại. Câu hỏi làm Thảo ngạc nhiên vô cùng:

	– Hả?

	Khuôn mặt trắng xanh của Nguyên đột nhiên lộ vẻ nghiêm trang. Nó lập lại:

	– Tại sao hả chị?

	Thảo và Nguyên chưa bao giờ đề cập đến vấn đề ấy từ khi ông Bình bắt đầu làm việc tại nhà. Thật cũng hơi kỳ lạ vì hai chị em chỉ cách nhau một vài tuổi, chúng nó rất thân với nhau, chuyện gì cũng nói với nhau.

	Nguyên lại hỏi:

	– Gia đình mình dọn về đây để ba làm việc trong Viện Đại Học, có phải không?

	– Đúng như thế …nhưng ba đã bị đuổi.- Thảo nói khẽ để tránh không cho ông Bình nghe được.

	– Nhưng tại sao? Ba đã làm nổ phòng thí nghiệm à?

	Nguyên mỉm cười với ý nghĩ ba nó có thể khiến nổ tung cái phòng thí nghiệm to lớn trong khuôn viên trường đại học ấy.

	Thảo lắc đầu:

	– Không, ba không làm nổ cái gì cả. Ba là một nhà thực vật học, chuyên nghiên cứu về thảo mộc, chỉ làm việc với cỏ cây hoa lá. Vậy thì ba đâu có cái gì để có thể làm chuyện “long trời lỡ đất” như thế được.

	Hai chị em bật cười to sau câu nói của Thảo.

	Vẫn với giọng khe khẽ, Thảo tiếp tục câu chuyện:

	– Chị không biết đích xác là chuyện gì đã xảy ra, nhưng có lần chị nghe ba nói chuyện điện thoại với ông Mạnh, viện trưởng Viện Đại Học. Em còn nhớ ông Mạnh không? Ông ta là người nhỏ con, ít nói đã có mặt trong bữa ăn tối ngày mà cái lò nướng thịt nhà mình bị bốc cháy đó?

	Nguyên gật đầu và hỏi:

	– Ông Mạnh đã sa thải ba phải không?

	Thảo thì thầm:

	– Có lẽ. Theo như chị hiểu thì chuyện ấy có dính dáng đến mấy cái cây do ba trồng trong phòng thí nghiệm và những thí nghiệm đó đã có kết quả ngược lại.

	Nói xong Thảo nhún vai:

	– Đó là tất cả những gì chị biết. Bây giờ, vào nhà thôi! Chị khát nước quá rồi!

	Rồi Thảo thè lưỡi ra và giả vờ rên rỉ như để chứng tỏ sự khát nước vô cùng của nó. Nguyên la lớn:

	– Chị làm em gớm quá!

	Nó mở cửa và chen vào nhà trước Thảo. Bà Bình đang đứng gần bồn rửa chén, quay lại:

	– Chuyện gì khiến con gớm vậy Nguyên?

	Thảo nhìn mẹ bỗng nhận thấy hôm nay mẹ có vẻ rất mệt mỏi. Vài nếp nhăn bắt đầu ẩn hiện ở đuôi mắt của mẹ thêm vào mái tóc đã điểm vài sợi bạc trắng.

	Bỗng chuông điện thoại reo vang. Bà Bình đang lột vỏ tôm, vội lau tay và hối hả nhấc điện thoại. Thảo lấy một hộp nước cam từ tủ lạnh ra, cắm vào đó một ống hút và theo chân Nguyên lên lầu. Chợt chúng nó nhận thấy cánh cửa dẫn xuống tầng dưới có phòng làm việc của ông Bình hé mở, khác hẵn với mọi hôm lúc nào cũng đóng chặt.

	Nguyên đưa tay định đóng lại nhưng không biết nghĩ sao nó dừng lại, đề nghị với Thảo:

	– Chúng mình xuống xem ba đang làm cái gì chị Thảo nhé!

	Thảo nuốt khỏi cổ những giọt nước cam cuối cùng rồi bóp dẹp chiếc hộp trong tay:

	– Ừ!

	Thảo cũng biết rằng chúng nó không nên làm phiền cha khi ông đang làm việc nhưng tính tò mò đã thắng lý trí. Cha chúng nó đã khởi sự làm việc trong căn phòng đó từ bốn tuần nay. Ông đã chở về chứa trong căn phòng đó rất nhiều thứ thật hấp dẫn đối với chúng nó: những bộ máy, những ngọn đèn và những loại cây cối lạ lùng. Mỗi ngày, ông giam mình trong ấy ít nhất 8 hoặc 9 tiếng đồng hồ để làm việc gì không ai biết. Và cho đến bây giờ ông cũng vẫn chưa cho chúng nó xem gì cả.

	Thảo quyết định:

	– Chúng mình đi xuống bây giờ nghe Nguyên!

	Thảo “biện hộ” cho quyết định của nó bằng ý nghĩ: “mình có quyền vào căn phòng ấy vì đây cũng là nhà của mình mà. Thêm vào đó, biết đâu ba rất mong việc làm của ba được gia đình chú ý và thích thú.. Ông sẽ cảm thấy bị tổn thương vì các con có vẻ lơ là, không hề ghé mắt vào việc ông đang làm.

	Thảo mở cánh cửa ra và hai chị em bước xuống cầu thang hẹp. Nguyên gọi lớn với một giọng sôi nổi:

	– Ba ơi! Tụi con có thể xuống xem ba làm việc không?

	Hai đứa xuống được nửa bậc thang thì thình lình ông Bình xuất hiện. Ông nhìn hai đứa con bằng một tia mắt giận dữ, làn da ông nhuộm một màu xanh lá cây rất kỳ lạ dưới ánh đèn huỳnh quang. Ông đang nắm chặt bàn tay mặt và chúng nó thấy rõ những giọt máu đỏ tươi rớt xuống chiếc áo choàng trắng của ông.

	– Tao cấm chúng mày bước xuống gian phòng này!..- ông hét lên bằng một giọng thật khủng khiếp mà Thảo và Nguyên chưa từng nghe ông nói với chúng bao giờ.

	Hai chị em lùi lại, ngạc nhiên nhìn thấy cha la hét như vậy, người cha mà từ trước đến nay rất dịu dàng với chúng nó.

	– Tao cấm chúng mày bước xuống đây, nghe rõ chưa? – ông Bình lập lại lời nói lúc nãy trong khi vẫn nắm giữ bàn tay bị thương – Tao cảnh cáo chúng mày tốt hơn hết là đừng bao giờ vào đây nữa!'),
	
	('MS004', 'MC002', N'Thí nghiệm', N'– Tôi đã chuẩn bị xong rồi!
	Bà Bình vừa nói lớn vừa buông mạnh hai chiếc va- ly trong hai tay xuống tạo thành một tiếng động nặng nề. Không nghe thấy có ai phản ứng sau câu nói đó, bà ló đầu nhìn vào phòng khách trong ấy chiếc máy truyền hình đang “rống” lên.

	– Các con có thể tạm ngưng chương trình truyền hình ấy để nói lời tạm biệt với mẹ trước khi mẹ lên đường được không?

	Nguyên bấm nút tắt máy. Thảo và Nguyên ngoan ngoản bước ra hôn giã từ mẹ.

	Kim, cô bạn thân của Thảo cũng theo gót bạn bước ra ngoài. Nhìn chăm chăm vào hai chiếc va- ly căng phồng, Kim hỏi:

	– Bác định sẽ đi bao nhiêu lâu hở bác?

	– Bác cũng chưa biết. Em gái của bác vào bệnh viện sáng này. Bác dự định rằng bác phải ở lại với cho đến khi dì ấy được phép về lại nhà.

	Kim đùa cợt:

	– Cháu rất hân hạnh được chăm sóc Thảo và Nguyên trong thời gian bác vắng mặt.

	– Tao lớn tuổi hơn mày Kim ạ! – Thảo trả đủa.

	Nguyên cũng xen vào với một giọng “khiêm tốn …giả vờ”:

	– Còn em là ngưòi thông minh hơn chị Thảo và Kim.

	Bà Bình sốt ruột liếc nhìn chiếc đồng hồ đeo tay:

	– Mẹ không lo lắng cho các con mà chỉ lo cho ba thôi.

	Thảo nghiêm trang thưa với mẹ:

	– Mẹ đừng lo, tụi con biết săn sóc ba mà!

	– Con nhớ để ý việc ăn uống của ba. Nhớ nhắc ba nuốt một miếng gì đó vào bụng chứ ba bị công việc lôi cuốn, ông quên cả ăn uống nên chúng ta phải nhớ dùm ông.

	Thảo nghĩ thầm:”Không có mẹ ở nhà chắc chắn khó mà có dịp thấy ba lên lầu”

	Đã hai tuần lễ trôi qua kể từ ngày ông cấm hai đứa con bước xuống tầng dưới nhà. Bắt đầu ngày ấy, hai đứa nó không dám bước mạnh mỗi khi đi ngang cánh cửa dẫn xuống tầng dưới, sợ ông nhớ chuyện cũ rồi lại nổi cơn lôi đình. Nhưng suốt trong hai tuần ấy, ông ít nói chuyện với chúng hơn, chỉ thỉnh thoảng chào hỏi qua loa buổi sáng thức dậy và buổi tối trước khi đi ngủ – nếu tình cờ ông và chúng nó chạm mặt nhau.

	Thảo trấn an mẹ với một nụ cười miễn cưỡng:

	– Mẹ yên tâm. Mẹ ráng săn sóc cho dì Hồng, mẹ nhé!

	– Mẹ sẽ điện thoại cho các con khi mẹ đến nơi.

	Bà Bình lại liếc nhìn chiếc đồng hồ đeo tay lần nữa. Không chờ đợi được nữa, bà bước nhanh về phía cánh cửa ngăn cách tầng trên và tầng dưới nhà:

	– Mình ơi! Đã tới giờ đưa tôi ra phi trường rồi!

	Bà chờ một lúc khá lâu mới nghe ông Bình trả lời. Bà thở hắt ra, quay nhìn các con, cố nói một câu dí dỏm nhưng ánh mắt bà lại lộ ra một vẻ buồn vô tận:

	– Mẹ chắc chắn sau khi mẹ đi, ba cũng sẽ không còn thời giờ để nhớ rằng mẹ đã vắng nhà …

	Vài giây sau, mọi người nghe tiếng chân bước trên thang lầu, cửa mở và ông Bình xuất hiện. Ông cởi chiếc áo choàng đầy vết dơ, máng nó lên tay vịn thang lầu. Họ thấy bàn tay bị thương của ông hai tuần trước đây vẫn còn băng kín.

	Ông hất hàm hỏi vợ:

	– Sẵn sàng chưa?

	Bà Bình thở dài ngao ngán:

	– Chắc là vậy!

	– Vậy thì đi, còn chờ gì nữa – ông Bình giục vợ.

	Ông nhấc hai chiếc va- ly lên rồi làu bàu:

	– Bà dự định sẽ đi bao lâu? Một năm à?

	Nói xong, không chờ câu trả lời của vợ, ông tiến về phía cửa chánh.

	Kim vẫy tay chào bà Bình:

	– Tạm biệt bác gái! Chúc bác một chuyến đi bình an, vui vẻ!

	Nguyên bực dọc:

	– Vô duyên! Em gái của mẹ đang nằm bệnh viện đấy cô nương à! Làm sao mẹ vui vẻ được?

	Chúng nó nhìn theo chiếc xe đi xa dần và mất hút mới trở vào phòng khách. Nguyên dành lấy máy truyền hình và tiếp tục xem phim. Kim buông phịch người xuống nằm trên chiếc ghế dài, vớ lấy gói khoai chiên đang ăn dở lúc nãy. Kim nói:

	– Tao còn cả đống bài chưa làm ở nhà. Không biết tao ở đây làm gì nữa!

	Thảo ngồi xếp bằng trên sàn, thở dài:

	– Tao cũng vậy. Tối nay tao sẽ làm. À, mầy có bài làm về Toán không? Tao bỏ quên quyển sách Toán ở trường rồi. Chiều nay trời đẹp quá, tụi mình nên đi ra ngoài chơi. Đi xe đạp chẳng hạn..

	Kim vừa nhai ngồm ngoàm vừa nói:

	– Chiều nào ở đây cũng đẹp cả. Tao sống nơi nầy đã lâu nên cũng chẳng để ý.

	– Hay là tụi mình làm Toán chung Kim nhé! – Thảo gạ gẫm Kim vì nó biết Kim giỏi Toán hơn nó nhiều.

	Kim nhún vai:

	– Cũng được.

	Thình lình, Kim hỏi bạn:

	– Tao để ý thấy ba mầy có vẻ căng thẳng lắm. Mầy có thấy như vậy không?

	– Hả? Mầy muốn nói điều gì?

	– Thì thần kinh căng thẳng đó! Sau khi ông bị sa thải, ông thế nào?

	Thảo đáp bằng một giọng buồn buồn:

	– Cũng khá! Tao không biết rõ lắm. Cả ngày ông chỉ ở dưới kia một mình để làm những cuộc thí nghiệm..

	Vừa nghe đến hai chữ “thí nghiệm”, Kim bật ngồi dậy. Nó mê nhất là môn Khoa Học và môn Toán, hai môn học mà Thảo ghét nhất:

	– Thí nghiệm? Ê, tụi mình nên đi xuống xem qua một chút.

	Nó tiếp tục hối thúc Thảo:

	– Này Thảo, ba mày chuyên về thực vật học phải không? Vậy thì ông đang phát minh cái gì ở dưới đó?

	– Chuyện rắc rối lắm – Thảo trả lời bạn. Ông hứa là sẽ giải thích cho tụi tao biết sau này. Nhưng …

	Kim đưa tay cho Thảo nắm để giúp Thảo đứng dậy.

	– … ông đã cấm chị em tao bước xuống dưới đó.

	Đôi mắt sáng như mắt mèo của Kim ngời lên ánh háo hức:

	– Đi xem một tí nha Thảo!

	– Không được!

	Thảo không thể nào quên được cái nhìn dữ dội của ba nó hai tuần trước đây khi chị em nó muốn xuống xem phòng làm việc của ông.

	Kim nói khích bạn:

	– Mày sợ à?

	– Không!

	– Đồ gà chết!

	Nói xong nó hất mái tóc dài ra sau lưng vẻ cương quyết nó tiến về phía cửa dẫn xuống tầng dưới.

	Thảo hoảng hốt chạy theo bạn và kêu lên:

	– Kim! Dừng lại!

	Nguyên đang chăm chú xem truyền hình, vội tắt máy:

	– Mấy người đi xuống dưới hả? Chờ em với!

	Nó đứng dậy thật nhanh và háo hức đứng cạnh hai đứa kia trước cánh cửa. Thảo cố ngăn cản:

	– Tụi mình không thể ….

	Nhưng Kim đã bịt miệng nó lại:

	– Tụi mình chỉ nhìn qua thôi. Chỉ nhìn thôi, không lục lọi tìm tòi gì cả, rồi mình đi lên lầu lại ngay.

	Nguyên đồng ý với Kim và cầm lấy cái tay nắm cửa:

	– Em sẽ tiên phong đi xuống trước!

	Thảo hỏi bạn:

	– Tại sao mầy cứ nhất quyết muốn xuống dưới đó?

	Kim nhún vai, mỉm cười bảo:

	– Còn hơn là phải làm bài Toán nhức óc kia!

	Thảo có vẻ xiêu lòng:

	– Được rồi, tụi mình cùng xuống. Nhưng phải luôn luôn nhớ rằng tụi mình đã đồng ý với nhau chỉ nhìn mà không sờ mó vào vật nào cả.

	Nguyên mở cửa ra. Vừa bước lên bậc thang thứ nhất, tức thì cả ba đứa đều cảm thấy toàn thân bị bao phủ bởi một bầu khí nóng và ẩm vô cùng. Dưới kia một luồng ánh sáng trắng chói loà phát ra từ phòng làm việc của ông Bình nằm ở phía tay mặt của chúng đồng thời với những tiếng máy chạy rì rầm phát ra đâu đó.

	Khi chúng nó đã bước xuống tới nơi, Thảo tự trấn an: “Mình chỉ muốn tìm vui thôi. Chỉ nhìn qua thôi cũng chẳng có gì hại.”

	Nghĩ như thế nhưng tại sao tim nó đập nhanh như thế, nó hồi hộp đến thế? Và tại sao bỗng dưng toàn thân nó ớn lạnh như có một cảm giác sợ hãi đang xâm chiếm?')

insert into NOIDUNGSACH values 
	('MS005', 'MC001', N'Hồi thứ nhất - Phần 1', N'Lời dẫn truyện

	Đi tìm sự thực lịch sử:

	Miếu thờ thừa tướng là đây

	Cấm thành rừng bách phủ đầy trước sau

	Nắng xuân cỏ biếc một màu

	Tiếng oanh trong lá tỏa vào không gian

	Ba lần cầu kiến cao nhân

	Hai triều đã tỏ lão thần tận tâm

	Kỳ sơn giữa trận từ trần

	Khách anh hùng để tần ngần lệ rơi.

	(Thừa tướng đất Thục – thơ Đỗ Phủ)

	Trong lịch sử hơn năm ngàn năm của Trung Quốc, Gia Cát Lượng là nhân vật truyền kỳ rất nổi tiếng, là một hình tượng rất đẹp.

	Những đức tính cao đẹp như trí, dũng, trung thành đều gộp cả ở con người ấy, suốt một thời đại đều in dấu ở chính khách rất được tán thưởng này, thậm chí đến cả những phục trang bên ngoài của ông như quạt lông, khăn nhiễu cũng đã thành y trang độc nhất vô nhị.

	Trong tác phẩm nổi tiếng Tam Quốc Diễn Nghĩa qua ngòi bút tô điểm của nhà viết tiểu thuyết La Quán Trung đời Minh, Gia Cát Lượng chẳng những là nhà tiên tri khả kính, nhà chiến lược đa mưu túc kế, nhà ngoại giao ăn nói hùng hồn, nhà chính trị nhìn xa trông rộng, nhà binh pháp xuất quỷ nhập thần, hơn nữa còn là một đạo gia thuật sĩ có tài hô phong hóan vũ, giẫm đạp thất tinh và có một siêu năng khác người.

	Mọi người ngưỡng mộ ông ở phong thái phong lưu, trí lự siêu phàm, tài kiêm văn võ, bất luận với một đối thủ lợi hại như thế nào, ví như những nhà quân sự thiên tài trong lịch sử Trung Quốc: Tào Tháo và Chu Du, ông đều coi là chẳng ra gì, lại còn đùa bỡn nữa. Có thể nói hết thảy những biến hóa trong trời đất ông đều sớm nắm chắc, song Gia Cát Lượng trong Tam Quốc Diễn Nghĩa, dẫu rằng được La Quán Trung tô vẽ và thần thoại hóa ra sao, liên tục sáu lần ra Kỳ Sơn, luôn đánh không thắng, cuối cùng phải nhận một kết cục bi thảm, gió thu thổi mãi gò Ngũ Trượng.

	Kỳ Sơn giữa trận từ trần

	Khách anh hùng để tần ngần lệ rơi.

	Vậy suy cho cùng, một đời Gia Cát Lượng là được hay là thua? Vì sao với trí tuệ và nỗ lực siêu phàm của ông vẫn không đem lại kết quả mong muốn? Vì sao với một chính khách không thành công như vậy, sau hai nghìn năm, trăm họ ở Tứ Xuyên vẫn còn nhắc đến những kỳ tích trị quốc ở đất Thục của ông. Và những văn nhân mặc khách nổi tiếng nghìn năm như Đỗ Phủ, Lý Bạch, Lý Thương Ẩn đều sùng bái ông, đến cả viên tướng thiên tài là Nhạc Phi đã lừng danh tận trung báo quốc, đều đã đọc kĩ bản viết Xuất Sư Biểu nổi tiếng của Gia Cát Lượng và cùng bày tỏ sự tôn sùng vô hạn đối với ông. Đằng sau lớp sương khói của cuốn tiểu thuyết, con người thực của Gia Cát Lượng rốt cục là như thế nào? Lý tưởng của ông, trí tuệ của ông, mưu lược của ông, phong cách của ông, cuối cùng đâu là cái ta có thể nắm bắt được; đấy cũng là vấn đề rất hứng thú mà cuốn sách này sẽ đề cập đến.

	1. Sức thu hút của Gia Cát Lượng là ở đâu?

	Gia Cát Lượng có tên chữ là Khổng Minh, ông sinh ra vào năm thứ 4 Đời Ninh đế nhà Hán (năm 181 sau Công Nguyên), ở huyện Dương Đô, quận Lang Nha (nay là huyện Nghi Thủy, tỉnh Sơn Đông). Huyện Dương Đô vẫn gọi là Gia Huyện, huyện này có rất nhiều người họ Cát, thế lực rất lớn, họ Cát này rất nổi trội nên thường được gọi là họ “Gia Cát”. Gia Cát Lượng xuất thân ở Phủ Quan. Tổ phụ của Gia Cát Lượng là Gia Cát Phong từng giữ chức Tư lệ hiệu úy (quan Tư lệnh cảnh bị kinh thành) nổi tiếng thanh liêm, bởi vậy cũng hay va chạm với không ít những kẻ quyền quý. Đến thời phụ thân của ông, chẳng còn hiển hách như xưa; phụ thân của Gia Cát Lượng thường trầm mặc ít nói, từng làm việc với chức Quận thừa ở quận Thái Sơn, song lẽ cụ sớm nhất, cho nên cũng chẳng có gì đáng kể. Đáng nói là ông chú của Gia Cát Lượng là Gia Cát Huyền, là người giỏi giao thiệp có văn tài thường hay qua lại với những kẻ có quyền thế quanh vùng như Viên Thuật, Lưu Biểu.

	Gia Cát Lượng có ba người anh em và một chị gái, do cha mẹ sớm mất, ở quê làng lại gặp phải loạn Hoàng Cân, ông chú là Gia Cát Huyền, mang cả nhà rời đến ở Thành Tương Dương lúc đó do Kinh Châu mục Lưu Biểu cai quản, định cư ở mé núi Nam Dương gần đô thành. Người anh cả là Gia Cát Cẩn đã lớn, để kế nghiệp cha đã đến học ở trường Thái học trong kinh thành Lạc Dương, về sau lại đến Đông Ngô theo lời mời của Lỗ Túc, thành ra một tân khách của Tôn Quyền, rồi ra làm quan với Đông Ngô, rất được Tôn Quyền sủng ái. Ít lâu sau, ông chú Gia Cát Huyền qua đời, Gia Cát Lượng và em trai Gia Cát Quân, dựa vào cái gia sản đạm bạc mà ông chú để lại, thường ngày cày ruộng, đọc sách, đợi có thời cơ để thi thố tài năng.

	Cũng do những mối thân tình từ trước, mà Gia Cát Lượng vẫn có quan hệ mật thiết với quý tộc ở thành Tương Dương. Gia Cát Lượng năm hai mươi tuổi lấy con gái nhà Hoàng Thừa Ngạn vốn có quan hệ thân thiết với Lưu Biểu đang làm quan Kinh Châu mục, và người chị gái của Gia Cát Lượng cũng đã lấy chồng là người quyền quý họ Bàng, sau này một người nổi tiếng tên là Phượng Sồ Bàng Thống cũng là người của họ ấy.

	Dân gian thường có câu “sức trói gà không nổi”, câu ấy dùng để chỉ cái vẻ thư sinh của Gia Cát Lượng, cũng dùng để nói cái ý rằng: ông là con người của đầu óc, thực ra lại không đúng với vẻ ngoài đích thực của ông.

	Gia Cát Lượng là người đạt được mức tiêu chuẩn của những chàng trai vạm vỡ đất Sơn Đông, thân cao dư 8 thước cổ xưa, chừng 1,8 m bây giờ, trông thể hình rất cao lớn, thời còn trẻ thường vẫn làm các việc cày bừa, thích tự làm lấy mà cũng làm luôn chân tay, thích sáng tạo ra các loại công cụ. Về cuối đời ông còn chế ra “nỏ liên châu”, “trâu gỗ ngựa máy”, thiết lập “bát trận đồ” tuyệt đối không phải là một tư tưởng gia đơn thuần chỉ động não động khâu mà không động tay chân.

	Ví như câu “sức trói gà không nổi”, cũng để chỉ một nhà chiến lược nổi tiếng thời Tây Hán là Trương Lương: Sách “Sử ký” miêu tả, ông ta “diện mạo giống như phụ nữ” là người thông tuệ, phong lưu và giàu tình cảm, là một mẫu mực thư sinh.

	Song Trương Lương vốn là kẻ to gan lớn mật, thời trẻ, để rửa nỗi nhục vong quốc, ông đã phải khuynh gia bại sản để học võ công, đâm Tần Thủy Hoàng ở Bác Lãng Sa. Tuy việc ấy không thành, song khi bị truy bắt khẩn cấp vẫn khôn khéo thóat khỏi, rõ ràng là người thư sinh này cũng đã sôi sục dòng máu vũ dũng trong người.

	Cũng ví như nói Gia Cát Lượng là người “sách hoạch cao thủ’’’ cũng hoàn toàn không đúng, ông thường nghiêm túc, trầm ngâm suy nghĩ, song hành động lại cẩn thận, mực thước, bởi vậy ít giao tiếp với bạn bè. Ở vào thời Đông Hán bấy giờ, giới thượng lưu chưa đánh giá cao đối với chàng thanh niên Gia Cát Lượng.

	Như Tam quốc chí đã ghi lại, Gia Cát Lượng thường ví mình với các danh tướng thời Xuân Thu như Quản Trọng, Nhạc Nghị, song lúc bây giờ, chỉ có những danh sĩ Kinh Châu thường qua lại với ông như Tư Mã Huy, Từ Thứ, Thôi Châu Bình, những người này không tài hoa bằng ông, xem những tư liệu của chính sử, Gia Cát Lượng là người trí tuệ tài giỏi, bên ngoài có vẻ trầm ngâm, bản tính là một người nghiêm túc; khi thảo luận công việc, nói năng sôi nổi, song thường thì rất ít nói, thích suy tư làm việc cẩn thận, quan sát thấu đáo, nắm chắc tình hình, lại có óc tổ chức và phân tích, làm việc có chuẩn bị và sách lược đúng, có khả năng suy tưởng, thực là một chuyên gia sách lược tiêu chuẩn.

	2. Đi tìm người tổng quản.

	Gia Cát Lượng lúc còn trẻ, về mặt suy tư so với người khác có những bất đồng rất lớn. Tam quốc chí kể rằng, ông thích đọc Lương Phụ Ngâm. Lương Phụ Ngâm là một khúc ca từng nói về tướng quốc Án Tử nước Tề, bởi muốn ổn định chính quyền nên đã bày ra kế trừ khử ba viên võ sĩ đối địch, khúc ca này nói về những sự kiện lịch sử có thật, qua đó cho thấy Gia Cát Lượng không hẹp hòi trong tập tục và truyền thống, đã dám vượt qua những ràng buộc tư tưởng của mình để thấy được chân tướng của sự kiện.

	Sau này nhìn lại, có thể thấy, chàng tuổi trẻ Gia Cát Lượng thời ấy là một người rất tự tin. Ông từng suy nghĩ rất nhiều, nhận rõ vai trò người tổng quản là rất trọng yếu trong “tập đoàn”, bởi vậy ông đã chọn “tập đoàn” Lưu -Quan – Trương, muốn được phát huy hết năng lực của mình. Đương nhiên để phát huy được sở trường, trừ những người thích tự do, việc đảm nhận trọng trách là rất đáng chú ý. Sau này Gia Cát Lượng giúp Lưu Bị đảm đương những công việc lớn, thực sự là người tổng quản cúc cung tận tụy, đến chết mới thôi.

	Lưu Bị lúc ấy đang bị Tào Tháo đuổi đến cùng đường miễn cưỡng phải tìm đến Kinh Châu nhờ Lưu Biểu che chở. Lưu Biểu danh nghĩa là đồng minh với Lưu Bị song thực tế để Lưu Bị ở Tân Dã huấn luyện binh sĩ tạo thành một phòng tuyến bên ngoài chống trả lại Tào Tháo mà thôi. Tuy tình hình quân sự rất khẩn cấp song Lưu Bị vẫn chưa thể yên lòng bởi chưa tạo dựng được sự nghiệp lớn, chưa tìm ra một chuyên gia hoạch định được kế hoạch lâu dài. Được sự tiến cử của những danh sĩ đất Kinh Tương là Tư Mã Huy và Từ Thứ, Lưu Bị nhận định rằng người ấy không trọng công danh, con người trẻ mưu lược ấy, chính là một nhân tài rất quan trọng trước mắt của “tập đoàn”, bởi thế ông nghe theo ý kiến của Từ Thứ, đích danh tự mình dẫn theo hai nhân vật quan trọng khác là Quan Vũ và Trương Phi, xông pha gió tuyết lạnh lẽo, đến cầu kiến ở lều cỏ của Gia Cát Lượng tại Long Trung.

	Để thử thành ý của Lưu Bị, Gia Cát Lượng cố ý lánh mặt liên tục hai lần không ở nhà để Lưu Bị phải về không. Song Lưu Bị không nản lòng, đã ba lần đến Long Trung cầu kiến. Gia Cát Lượng rất cảm động, phải ở nhà chờ đợi để đáp lại. “Tam cố thảo lư cầu Gia Cát Lượng” là một giai thoại dã sử nổi tiếng nghìn năm. Trong bản viết Xuất Sư Biểu của Gia Cát Lượng sau này có viết “Tiên đế chẳng xem thần nhỏ mọn, ở nơi lẩn khuất, ba lần chiếu cố đến thần giữa nơi lều cỏ”, có thể coi đây là một sự thực lịch sử kể về ba lần cầu kiến Khổng Minh.

	Lưu Bị lúc này đã bốn tám tuổi, dấn thân dựng nghiệp đã hai mốt năm, có uy tín lớn với toàn quốc, từng giữ các chức: Từ châu mục và Dự châu mục (chức quan đứng đầu về quân sự ở địa phương). Gia Cát Lượng mới hai bảy tuổi là một “lính mới” vừa xong tu nghiệp, song Lưu Bị đã nhất nhất nghe theo “Long Trung Sách”, kế sách quan trọng của Gia Cát Lượng.

	Long Trung Sách được đưa ra khi hai người vừa mới biết nhau, hoạch định được kế hoạch lâu dài cho Lưu Bị. Hôm ấy, Gia Cát Lượng và Lưu Bị cùng đàm đạo rất tâm đắc, bản Long Trung Sách hiện còn lại là bản viết giản đơn do người đời sau chỉnh lý, song qua đó ta có thể thấy được ý tứ của nhà chiến lược trẻ tuổi là “giữ toàn tính mệnh ở đời loạn, chẳng cần nổi tiếng với chư hầu”, để mưu sự nghiệp to lớn về sau. Ông đã phân tích sáng suốt thời cục hiện tại với một nhãn quan thấu đáo, đề ra kế sách từng bước đi từ nhỏ đến lớn, trách chi mà Lưu Bị mừng như cá gặp nước vậy. Xem xét những cố gắng và việc làm của Gia Cát Lượng sau khi hạ sơn, có thể chia làm ba giai đoạn, mỗi lúc nổi trội khác nhau, dễ thấy những phong cách và kế sách không giống nhau.

	Giai đoạn thứ nhất kể về một “Quân sư” nổi tiếng từ trụ quân ở Tân Dã, rồi đến cuộc chiến ở Tương Dương, đại chiến ở Xích Bích, có được Kinh Châu, Hán Trung đều thấy vai trò phụ tá quan trọng của Gia Cát Lượng bên cạnh chủ tướng Lưu Bị, cho thấy rõ tính nổi trội ở những kế sách của ông.

	Giai đoạn thứ hai kể vể nhà “Chính trị gia” nổi tiếng: kể từ Lưu Bị tự phong là Hán Trung Vương, cho đến giai đoạn thành Bạch Đế gửi con. Đoạn này bề ngoài là Lưu Bị nắm quyền, song bên trong Gia Cát Lượng điều hành, tỏ rõ vai trò một người tổng quản lý tài giỏi kiến tạo cơ cấu phụ trách, chi viện hậu cần đưa mọi việc vào qui củ, thành vai chính trên sàn diễn.

	Giai đoạn thứ ba kế về một “Tổng tư lệnh” viễn chinh nổi tiếng, kể từ bắt đầu chiến dịch nam chinh tháng 5 vượt qua Lô Giang, đến bắc phạt Trung Nguyên, đến gò Ngũ Trượng mắc trọng bệnh từ trần ở giữa doanh trại. Gia Cát Lượng đã trở thành người tổng quản lý khai sáng cơ nghiệp, điều hành mọi việc trong nước.

	Tác giả của Tam Quốc Diễn Nghĩa đã miêu tả Gia Cát Lượng trong một luồng sáng rực rỡ, với nhiều tình tiết như nhờ sương mù mượn tên, mượn gió đông hỏa thiêu Xích Bích, sáu lần ra Kỳ Sơn, hỏa thiêu Cơ Cốc, bát trận đồ gây khốn Lục Tốn, Gia Cát Lượng đã chết mà đuổi được Trọng Đạt sống v.v…, cơ hồ như Gia Cát Lượng là một thiên tài quân sự siêu năng xưa nay chưa có, xuất quỷ nhập thần; song theo ghi chép của cuốn sử “Tam Quốc Chí” của tác giả Trần Thọ, thì Gia Cát Lượng được thể hiện rất thực qua ba giai đoạn, nhất là qua giai đoạn hai.

	Bình phẩm vê Gia Cát Lượng, tác giả Trần Thọ viết:

	“Gia Cát Lượng giữ chức tướng quốc, vỗ yên bách tính, tỏ rõ nghi thức, sắp xếp quan chức, điều hành chính sự, khai sáng dân tâm cùng là ban bố pháp luật… Có thể nói ông là bậc hiền tài trị quốc, sánh được với các năng thần như Quản Trọng, Tiêu Hà, song liên tục nhiều năm huy động sức dân đánh mãi không thắng nói về tháo vát ứng biến, có thể đó chẳng phải là sở trường vậy’’.

	Cứ như sử liệu mà xem, xét lời bình của Trần Thọ, đối chiếu với sự miêu tả của La Quán Trung, nghĩ rằng cũng nên tìm hiểu con người Gia Cát Lượng một cách chân thực.

	3. Quân sư trẻ tuổi với ngoại giao con thoi và sách lược rõ ràng.

	Kể từ Tào Tháo mang đại quân xâm nhập Kinh Châu cho đến cuộc chiến ở Xích Bích, thấy sự nghiệp của Lưu Bị ở vào vị trí rất chông chênh. Ở giai đoạn này, Gia Cát Lượng đã phát huy mưu lược và tài cán ngoại giao, giúp đỡ rất nhiều cho Lưu Bị. Tam Quốc Diễn Nghĩa đã miêu tả thiên tài quân sự tuyệt vời của ông, ví như trận hỏa thiêu gò Bác Vọng và đại chiến Xích Bích thiêu hủy đoàn thuyền liên hoàn đều quy tụ ở công lao của ông, câu chuyện mượn gió đông mang đầy màu sắc thần thoại. Kỳ thực Gia Cát Lượng lúc đó còn ít tuổi, lại thiếu kinh nghiệm chiến đấu, được lưu ở tuyến sau, cống hiến thực sự của ông chỉ là lo liệu việc hậu cần.

	Sau chiến dịch Tương Dương, Trường Bản, đội quân của Lưu Bị tan tác cả. Trong vạn phần nguy cấp, cũng nhờ Lỗ Túc dẫn lối Gia Cát Lượng, phục mệnh sang Giang Đông thuyết phục Tôn Quyền, để ông ta xuất binh cùng với Lưu Bị liên hợp chống trả Tào Tháo. Đấy chẳng những phải thuyết phục Tôn Quyền, mà phải chinh phục được cả quần thần văn võ của Đông Ngô, có thể nói là một nhiệm vụ rất khó khăn.

	Đảm nhiệm việc sưu tầm tình báo đưa ra phán đóan tổng hợp, Gia Cát Lượng đã thành công trong việc triển khai ngoại giao con thoi. Nhờ được sự giúp đỡ của Lỗ Túc, Gia Cát Lượng đã có biểu hiện kiệt suất, ông trù liệu chính xác, phân tích rõ ràng, khi cứng, khi mềm, khi thuận theo, khi khích tướng, cuối cùng hiệp trợ Tôn Quyền thắng được phái chủ hòa trong nước, xuất binh tiến hành một trận quyết chiến với Tào Tháo ở Xích Bích, có thể nói đã traọ chiếc chìa khóa mở cửa cho sự nghiệp của Lưu Bị được tiến triển.

	Trong cuộc chiến ở Xích Bích, thực tế là cuộc đối đầu giữa tập đoàn quân do Tào Tháo chỉ huy với thủy lục quân Đông Ngô do Chu Du chỉ huy. Đội quân của Tào Tháo bị chết trận và tan rã hơn mười vạn người mà bản thân Chu Du trong chiến dịch Giang Lăng sau đó cũng bị thương nặng, dẫn đến phải chết trong doanh trại, hai bên Tào Tháo và Tôn Quyền đều bị bại hoại, rốt cục người thu lợi chủ yếu lại là Lưu Bị. Tuy vậy Tào Nhân vẫn còn hùng cứ ở Tương Dương, Kinh Châu; Chu Du vẫn nắm giữ Giang Lăng, một vị trí quân sự quan trọng bên sông Trường Giang. Xong ở phía tây nam, một nửa phần Kinh Châu là ba quận Linh Lăng, Quế Dương, Trường Sa đã bị quân của Lưu Bị thừa cơ chiếm lấy, tạo ra đất sáng nghiệp trọng yếu của Lưu Bị, kế hoạch trên giấy “Long Trung Sách” của Gia Cát Lượng đã tiến được một bước có thể nói đã thành công được một nửa.

	Tuy ở giai đoạn này Gia Cát Lượng chưa tác động nhiều lắm đến sự sáng nghiệp của Lưu Bị, song việc phát triển sự nghiệp của Lưu Bị vẫn nằm trong quy hoạch phát triển của Gia Cát Lượng. Bước thứ hai của “Long Trung Sách” nhằm vào Ích Châu ở phía tây không lâu nữa cơ hội lại đến.

	Lưu Chương chiếm cứ Ích Châu, do nhiều năm bị quân Trương Lỗ ở Hán Trung phương bắc quấy nhiễu, thể theo những đề nghị của các trung thần Trương Tùng và Pháp Chính, đã chủ động mời quân của Lưu Bị đến giúp.

	Lưu Bị để Gia Cát Lượng hiệp trợ với Quan Vũ và Trương Phi trấn thủ Kinh Châu, tự mình dẫn theo Hoàng Trung tiến vào Ích Châu, còn có tổng tham mưu trứ danh Phượng Sồ tiên sinh. Trong đoàn xuất quân này, có thể thấy Lưu Bị rất xem trọng Gia Cát Lượng quân sư, tuy không xếp vào hàng mưu lược quân sự, song lại đặt ở vị trí điều hành hậu cần, giống như Tiêu Hà với Lưu Bang.

	Không bao lâu, các cánh quân của Lưu Bị tiến vào Ích Châu gặp phải sự cản trở của quân Lưu Chương, đội quân của Hoàng Trung tuy dũng mãnh thiện chiến, song lẽ thế đơn lực mỏng khó địch lại được đại quân bên Thục. Lưu Bị vội hạ lệnh Quan Vũ trấn thủ Kinh Châu, hai đội quân của Trương Phi và Triệu Vân theo hướng sông Nghi cùng tiến vào Ích Châu, hẹn hợp với quân Hoàng Trung cùng đánh Thành Đô.

	Tổng tham mưu trưởng của Trương Phi và Triệu Vân là Gia Cát Lượng, đây cũng là lần thứ nhất Gia Cát Lượng chủ động lãnh đạo việc quân. Do hai hộ tướng Trương Phi, Triệu Vân dốc lực phối hợp, khiến cuộc tấn công lần này gần như nắm chắc phần thắng.

	Không lâu, trong lần tiến đánh Thành Đô, Bàng Thống không may tử nạn, công việc tổng tham mưu chinh phạt đất Thục lại ở cả trong tay Gia Cát Lượng.

	Do thanh thế đội quân Lưu Bị rất lớn, lại có Pháp Chính trong đất Thục làm nội ứng, Lưu Chương thấy đại thế đã vỡ, bèn xin đầu hàng Lưu Bị. Bước thứ hai rất quan trọng mà “Long Trung Sách” đã hoạch định cũng là công việc khuếch triển rất khó khăn đã đạt được thành công thuận lợi.

	Sau khi chiếm được Ích Châu, không lâu Lưu Bị lại dẫn đội quân của Hoàng Trung và Triệu Vân, đánh vào đội quân Hạ Hầu Uyên được Tào Tháo phái đến Hán Trung, lấy sách lược đánh lâu dài, khiến đội quân viễn chinh của Tào Tháo không được viện trợ phải rút lui. Lưu Bị đã dần dần từng bước đi từ nhỏ đến lớn, sau tám năm Gia Cát Lượng hạ sơn giúp đỡ, đã tạo nên một kỳ tích là lập nên thế chân vạc chia ba thiên hạ (từ năm 207 đến 215). Trần Thọ trong Tam Quốc Chí viết rằng:

	“Lưu Bị sau khi bình định được Thành Đô, phong Gia Cát Lượng là Quân sư tướng quân, chức Tả tướng quân (đây là chức quan quan trọng của Lưu Bị) để trông coi việc lớn. Lưu Bị thường dẫn quân đội đi chinh chiến bên ngoài để Gia Cát Lượng ở Thành Đô trông coi triều chính, chẳng bao lâu khắp vùng Ích Châu đều dư thực dư binh”.

	Từ đó có thể thấy Gia Cát Lượng có tài điều hành và lập kế sách là một trợ thủ rất lớn bên cạnh Lưu Bị.

	Lời dẫn truyện

	Đi tìm sự thực lịch sử:

	Miếu thờ thừa tướng là đây

	Cấm thành rừng bách phủ đầy trước sau

	Nắng xuân cỏ biếc một màu

	Tiếng oanh trong lá tỏa vào không gian

	Ba lần cầu kiến cao nhân

	Hai triều đã tỏ lão thần tận tâm

	Kỳ sơn giữa trận từ trần

	Khách anh hùng để tần ngần lệ rơi.

	(Thừa tướng đất Thục – thơ Đỗ Phủ)

	Trong lịch sử hơn năm ngàn năm của Trung Quốc, Gia Cát Lượng là nhân vật truyền kỳ rất nổi tiếng, là một hình tượng rất đẹp.

	Những đức tính cao đẹp như trí, dũng, trung thành đều gộp cả ở con người ấy, suốt một thời đại đều in dấu ở chính khách rất được tán thưởng này, thậm chí đến cả những phục trang bên ngoài của ông như quạt lông, khăn nhiễu cũng đã thành y trang độc nhất vô nhị.

	Trong tác phẩm nổi tiếng Tam Quốc Diễn Nghĩa qua ngòi bút tô điểm của nhà viết tiểu thuyết La Quán Trung đời Minh, Gia Cát Lượng chẳng những là nhà tiên tri khả kính, nhà chiến lược đa mưu túc kế, nhà ngoại giao ăn nói hùng hồn, nhà chính trị nhìn xa trông rộng, nhà binh pháp xuất quỷ nhập thần, hơn nữa còn là một đạo gia thuật sĩ có tài hô phong hóan vũ, giẫm đạp thất tinh và có một siêu năng khác người.

	Mọi người ngưỡng mộ ông ở phong thái phong lưu, trí lự siêu phàm, tài kiêm văn võ, bất luận với một đối thủ lợi hại như thế nào, ví như những nhà quân sự thiên tài trong lịch sử Trung Quốc: Tào Tháo và Chu Du, ông đều coi là chẳng ra gì, lại còn đùa bỡn nữa. Có thể nói hết thảy những biến hóa trong trời đất ông đều sớm nắm chắc, song Gia Cát Lượng trong Tam Quốc Diễn Nghĩa, dẫu rằng được La Quán Trung tô vẽ và thần thoại hóa ra sao, liên tục sáu lần ra Kỳ Sơn, luôn đánh không thắng, cuối cùng phải nhận một kết cục bi thảm, gió thu thổi mãi gò Ngũ Trượng.

	Kỳ Sơn giữa trận từ trần

	Khách anh hùng để tần ngần lệ rơi.

	Vậy suy cho cùng, một đời Gia Cát Lượng là được hay là thua? Vì sao với trí tuệ và nỗ lực siêu phàm của ông vẫn không đem lại kết quả mong muốn? Vì sao với một chính khách không thành công như vậy, sau hai nghìn năm, trăm họ ở Tứ Xuyên vẫn còn nhắc đến những kỳ tích trị quốc ở đất Thục của ông. Và những văn nhân mặc khách nổi tiếng nghìn năm như Đỗ Phủ, Lý Bạch, Lý Thương Ẩn đều sùng bái ông, đến cả viên tướng thiên tài là Nhạc Phi đã lừng danh tận trung báo quốc, đều đã đọc kĩ bản viết Xuất Sư Biểu nổi tiếng của Gia Cát Lượng và cùng bày tỏ sự tôn sùng vô hạn đối với ông. Đằng sau lớp sương khói của cuốn tiểu thuyết, con người thực của Gia Cát Lượng rốt cục là như thế nào? Lý tưởng của ông, trí tuệ của ông, mưu lược của ông, phong cách của ông, cuối cùng đâu là cái ta có thể nắm bắt được; đấy cũng là vấn đề rất hứng thú mà cuốn sách này sẽ đề cập đến.

	1. Sức thu hút của Gia Cát Lượng là ở đâu?

	Gia Cát Lượng có tên chữ là Khổng Minh, ông sinh ra vào năm thứ 4 Đời Ninh đế nhà Hán (năm 181 sau Công Nguyên), ở huyện Dương Đô, quận Lang Nha (nay là huyện Nghi Thủy, tỉnh Sơn Đông). Huyện Dương Đô vẫn gọi là Gia Huyện, huyện này có rất nhiều người họ Cát, thế lực rất lớn, họ Cát này rất nổi trội nên thường được gọi là họ “Gia Cát”. Gia Cát Lượng xuất thân ở Phủ Quan. Tổ phụ của Gia Cát Lượng là Gia Cát Phong từng giữ chức Tư lệ hiệu úy (quan Tư lệnh cảnh bị kinh thành) nổi tiếng thanh liêm, bởi vậy cũng hay va chạm với không ít những kẻ quyền quý. Đến thời phụ thân của ông, chẳng còn hiển hách như xưa; phụ thân của Gia Cát Lượng thường trầm mặc ít nói, từng làm việc với chức Quận thừa ở quận Thái Sơn, song lẽ cụ sớm nhất, cho nên cũng chẳng có gì đáng kể. Đáng nói là ông chú của Gia Cát Lượng là Gia Cát Huyền, là người giỏi giao thiệp có văn tài thường hay qua lại với những kẻ có quyền thế quanh vùng như Viên Thuật, Lưu Biểu.

	Gia Cát Lượng có ba người anh em và một chị gái, do cha mẹ sớm mất, ở quê làng lại gặp phải loạn Hoàng Cân, ông chú là Gia Cát Huyền, mang cả nhà rời đến ở Thành Tương Dương lúc đó do Kinh Châu mục Lưu Biểu cai quản, định cư ở mé núi Nam Dương gần đô thành. Người anh cả là Gia Cát Cẩn đã lớn, để kế nghiệp cha đã đến học ở trường Thái học trong kinh thành Lạc Dương, về sau lại đến Đông Ngô theo lời mời của Lỗ Túc, thành ra một tân khách của Tôn Quyền, rồi ra làm quan với Đông Ngô, rất được Tôn Quyền sủng ái. Ít lâu sau, ông chú Gia Cát Huyền qua đời, Gia Cát Lượng và em trai Gia Cát Quân, dựa vào cái gia sản đạm bạc mà ông chú để lại, thường ngày cày ruộng, đọc sách, đợi có thời cơ để thi thố tài năng.

	Cũng do những mối thân tình từ trước, mà Gia Cát Lượng vẫn có quan hệ mật thiết với quý tộc ở thành Tương Dương. Gia Cát Lượng năm hai mươi tuổi lấy con gái nhà Hoàng Thừa Ngạn vốn có quan hệ thân thiết với Lưu Biểu đang làm quan Kinh Châu mục, và người chị gái của Gia Cát Lượng cũng đã lấy chồng là người quyền quý họ Bàng, sau này một người nổi tiếng tên là Phượng Sồ Bàng Thống cũng là người của họ ấy.

	Dân gian thường có câu “sức trói gà không nổi”, câu ấy dùng để chỉ cái vẻ thư sinh của Gia Cát Lượng, cũng dùng để nói cái ý rằng: ông là con người của đầu óc, thực ra lại không đúng với vẻ ngoài đích thực của ông.

	Gia Cát Lượng là người đạt được mức tiêu chuẩn của những chàng trai vạm vỡ đất Sơn Đông, thân cao dư 8 thước cổ xưa, chừng 1,8 m bây giờ, trông thể hình rất cao lớn, thời còn trẻ thường vẫn làm các việc cày bừa, thích tự làm lấy mà cũng làm luôn chân tay, thích sáng tạo ra các loại công cụ. Về cuối đời ông còn chế ra “nỏ liên châu”, “trâu gỗ ngựa máy”, thiết lập “bát trận đồ” tuyệt đối không phải là một tư tưởng gia đơn thuần chỉ động não động khâu mà không động tay chân.

	Ví như câu “sức trói gà không nổi”, cũng để chỉ một nhà chiến lược nổi tiếng thời Tây Hán là Trương Lương: Sách “Sử ký” miêu tả, ông ta “diện mạo giống như phụ nữ” là người thông tuệ, phong lưu và giàu tình cảm, là một mẫu mực thư sinh.

	Song Trương Lương vốn là kẻ to gan lớn mật, thời trẻ, để rửa nỗi nhục vong quốc, ông đã phải khuynh gia bại sản để học võ công, đâm Tần Thủy Hoàng ở Bác Lãng Sa. Tuy việc ấy không thành, song khi bị truy bắt khẩn cấp vẫn khôn khéo thóat khỏi, rõ ràng là người thư sinh này cũng đã sôi sục dòng máu vũ dũng trong người.

	Cũng ví như nói Gia Cát Lượng là người “sách hoạch cao thủ’’’ cũng hoàn toàn không đúng, ông thường nghiêm túc, trầm ngâm suy nghĩ, song hành động lại cẩn thận, mực thước, bởi vậy ít giao tiếp với bạn bè. Ở vào thời Đông Hán bấy giờ, giới thượng lưu chưa đánh giá cao đối với chàng thanh niên Gia Cát Lượng.

	Như Tam quốc chí đã ghi lại, Gia Cát Lượng thường ví mình với các danh tướng thời Xuân Thu như Quản Trọng, Nhạc Nghị, song lúc bây giờ, chỉ có những danh sĩ Kinh Châu thường qua lại với ông như Tư Mã Huy, Từ Thứ, Thôi Châu Bình, những người này không tài hoa bằng ông, xem những tư liệu của chính sử, Gia Cát Lượng là người trí tuệ tài giỏi, bên ngoài có vẻ trầm ngâm, bản tính là một người nghiêm túc; khi thảo luận công việc, nói năng sôi nổi, song thường thì rất ít nói, thích suy tư làm việc cẩn thận, quan sát thấu đáo, nắm chắc tình hình, lại có óc tổ chức và phân tích, làm việc có chuẩn bị và sách lược đúng, có khả năng suy tưởng, thực là một chuyên gia sách lược tiêu chuẩn.

	2. Đi tìm người tổng quản.

	Gia Cát Lượng lúc còn trẻ, về mặt suy tư so với người khác có những bất đồng rất lớn. Tam quốc chí kể rằng, ông thích đọc Lương Phụ Ngâm. Lương Phụ Ngâm là một khúc ca từng nói về tướng quốc Án Tử nước Tề, bởi muốn ổn định chính quyền nên đã bày ra kế trừ khử ba viên võ sĩ đối địch, khúc ca này nói về những sự kiện lịch sử có thật, qua đó cho thấy Gia Cát Lượng không hẹp hòi trong tập tục và truyền thống, đã dám vượt qua những ràng buộc tư tưởng của mình để thấy được chân tướng của sự kiện.

	Sau này nhìn lại, có thể thấy, chàng tuổi trẻ Gia Cát Lượng thời ấy là một người rất tự tin. Ông từng suy nghĩ rất nhiều, nhận rõ vai trò người tổng quản là rất trọng yếu trong “tập đoàn”, bởi vậy ông đã chọn “tập đoàn” Lưu -Quan – Trương, muốn được phát huy hết năng lực của mình. Đương nhiên để phát huy được sở trường, trừ những người thích tự do, việc đảm nhận trọng trách là rất đáng chú ý. Sau này Gia Cát Lượng giúp Lưu Bị đảm đương những công việc lớn, thực sự là người tổng quản cúc cung tận tụy, đến chết mới thôi.

	Lưu Bị lúc ấy đang bị Tào Tháo đuổi đến cùng đường miễn cưỡng phải tìm đến Kinh Châu nhờ Lưu Biểu che chở. Lưu Biểu danh nghĩa là đồng minh với Lưu Bị song thực tế để Lưu Bị ở Tân Dã huấn luyện binh sĩ tạo thành một phòng tuyến bên ngoài chống trả lại Tào Tháo mà thôi. Tuy tình hình quân sự rất khẩn cấp song Lưu Bị vẫn chưa thể yên lòng bởi chưa tạo dựng được sự nghiệp lớn, chưa tìm ra một chuyên gia hoạch định được kế hoạch lâu dài. Được sự tiến cử của những danh sĩ đất Kinh Tương là Tư Mã Huy và Từ Thứ, Lưu Bị nhận định rằng người ấy không trọng công danh, con người trẻ mưu lược ấy, chính là một nhân tài rất quan trọng trước mắt của “tập đoàn”, bởi thế ông nghe theo ý kiến của Từ Thứ, đích danh tự mình dẫn theo hai nhân vật quan trọng khác là Quan Vũ và Trương Phi, xông pha gió tuyết lạnh lẽo, đến cầu kiến ở lều cỏ của Gia Cát Lượng tại Long Trung.

	Để thử thành ý của Lưu Bị, Gia Cát Lượng cố ý lánh mặt liên tục hai lần không ở nhà để Lưu Bị phải về không. Song Lưu Bị không nản lòng, đã ba lần đến Long Trung cầu kiến. Gia Cát Lượng rất cảm động, phải ở nhà chờ đợi để đáp lại. “Tam cố thảo lư cầu Gia Cát Lượng” là một giai thoại dã sử nổi tiếng nghìn năm. Trong bản viết Xuất Sư Biểu của Gia Cát Lượng sau này có viết “Tiên đế chẳng xem thần nhỏ mọn, ở nơi lẩn khuất, ba lần chiếu cố đến thần giữa nơi lều cỏ”, có thể coi đây là một sự thực lịch sử kể về ba lần cầu kiến Khổng Minh.

	Lưu Bị lúc này đã bốn tám tuổi, dấn thân dựng nghiệp đã hai mốt năm, có uy tín lớn với toàn quốc, từng giữ các chức: Từ châu mục và Dự châu mục (chức quan đứng đầu về quân sự ở địa phương). Gia Cát Lượng mới hai bảy tuổi là một “lính mới” vừa xong tu nghiệp, song Lưu Bị đã nhất nhất nghe theo “Long Trung Sách”, kế sách quan trọng của Gia Cát Lượng.

	Long Trung Sách được đưa ra khi hai người vừa mới biết nhau, hoạch định được kế hoạch lâu dài cho Lưu Bị. Hôm ấy, Gia Cát Lượng và Lưu Bị cùng đàm đạo rất tâm đắc, bản Long Trung Sách hiện còn lại là bản viết giản đơn do người đời sau chỉnh lý, song qua đó ta có thể thấy được ý tứ của nhà chiến lược trẻ tuổi là “giữ toàn tính mệnh ở đời loạn, chẳng cần nổi tiếng với chư hầu”, để mưu sự nghiệp to lớn về sau. Ông đã phân tích sáng suốt thời cục hiện tại với một nhãn quan thấu đáo, đề ra kế sách từng bước đi từ nhỏ đến lớn, trách chi mà Lưu Bị mừng như cá gặp nước vậy. Xem xét những cố gắng và việc làm của Gia Cát Lượng sau khi hạ sơn, có thể chia làm ba giai đoạn, mỗi lúc nổi trội khác nhau, dễ thấy những phong cách và kế sách không giống nhau.

	Giai đoạn thứ nhất kể về một “Quân sư” nổi tiếng từ trụ quân ở Tân Dã, rồi đến cuộc chiến ở Tương Dương, đại chiến ở Xích Bích, có được Kinh Châu, Hán Trung đều thấy vai trò phụ tá quan trọng của Gia Cát Lượng bên cạnh chủ tướng Lưu Bị, cho thấy rõ tính nổi trội ở những kế sách của ông.

	Giai đoạn thứ hai kể vể nhà “Chính trị gia” nổi tiếng: kể từ Lưu Bị tự phong là Hán Trung Vương, cho đến giai đoạn thành Bạch Đế gửi con. Đoạn này bề ngoài là Lưu Bị nắm quyền, song bên trong Gia Cát Lượng điều hành, tỏ rõ vai trò một người tổng quản lý tài giỏi kiến tạo cơ cấu phụ trách, chi viện hậu cần đưa mọi việc vào qui củ, thành vai chính trên sàn diễn.

	Giai đoạn thứ ba kế về một “Tổng tư lệnh” viễn chinh nổi tiếng, kể từ bắt đầu chiến dịch nam chinh tháng 5 vượt qua Lô Giang, đến bắc phạt Trung Nguyên, đến gò Ngũ Trượng mắc trọng bệnh từ trần ở giữa doanh trại. Gia Cát Lượng đã trở thành người tổng quản lý khai sáng cơ nghiệp, điều hành mọi việc trong nước.

	Tác giả của Tam Quốc Diễn Nghĩa đã miêu tả Gia Cát Lượng trong một luồng sáng rực rỡ, với nhiều tình tiết như nhờ sương mù mượn tên, mượn gió đông hỏa thiêu Xích Bích, sáu lần ra Kỳ Sơn, hỏa thiêu Cơ Cốc, bát trận đồ gây khốn Lục Tốn, Gia Cát Lượng đã chết mà đuổi được Trọng Đạt sống v.v…, cơ hồ như Gia Cát Lượng là một thiên tài quân sự siêu năng xưa nay chưa có, xuất quỷ nhập thần; song theo ghi chép của cuốn sử “Tam Quốc Chí” của tác giả Trần Thọ, thì Gia Cát Lượng được thể hiện rất thực qua ba giai đoạn, nhất là qua giai đoạn hai.

	Bình phẩm vê Gia Cát Lượng, tác giả Trần Thọ viết:

	“Gia Cát Lượng giữ chức tướng quốc, vỗ yên bách tính, tỏ rõ nghi thức, sắp xếp quan chức, điều hành chính sự, khai sáng dân tâm cùng là ban bố pháp luật… Có thể nói ông là bậc hiền tài trị quốc, sánh được với các năng thần như Quản Trọng, Tiêu Hà, song liên tục nhiều năm huy động sức dân đánh mãi không thắng nói về tháo vát ứng biến, có thể đó chẳng phải là sở trường vậy’’.

	Cứ như sử liệu mà xem, xét lời bình của Trần Thọ, đối chiếu với sự miêu tả của La Quán Trung, nghĩ rằng cũng nên tìm hiểu con người Gia Cát Lượng một cách chân thực.

	3. Quân sư trẻ tuổi với ngoại giao con thoi và sách lược rõ ràng.

	Kể từ Tào Tháo mang đại quân xâm nhập Kinh Châu cho đến cuộc chiến ở Xích Bích, thấy sự nghiệp của Lưu Bị ở vào vị trí rất chông chênh. Ở giai đoạn này, Gia Cát Lượng đã phát huy mưu lược và tài cán ngoại giao, giúp đỡ rất nhiều cho Lưu Bị. Tam Quốc Diễn Nghĩa đã miêu tả thiên tài quân sự tuyệt vời của ông, ví như trận hỏa thiêu gò Bác Vọng và đại chiến Xích Bích thiêu hủy đoàn thuyền liên hoàn đều quy tụ ở công lao của ông, câu chuyện mượn gió đông mang đầy màu sắc thần thoại. Kỳ thực Gia Cát Lượng lúc đó còn ít tuổi, lại thiếu kinh nghiệm chiến đấu, được lưu ở tuyến sau, cống hiến thực sự của ông chỉ là lo liệu việc hậu cần.

	Sau chiến dịch Tương Dương, Trường Bản, đội quân của Lưu Bị tan tác cả. Trong vạn phần nguy cấp, cũng nhờ Lỗ Túc dẫn lối Gia Cát Lượng, phục mệnh sang Giang Đông thuyết phục Tôn Quyền, để ông ta xuất binh cùng với Lưu Bị liên hợp chống trả Tào Tháo. Đấy chẳng những phải thuyết phục Tôn Quyền, mà phải chinh phục được cả quần thần văn võ của Đông Ngô, có thể nói là một nhiệm vụ rất khó khăn.

	Đảm nhiệm việc sưu tầm tình báo đưa ra phán đóan tổng hợp, Gia Cát Lượng đã thành công trong việc triển khai ngoại giao con thoi. Nhờ được sự giúp đỡ của Lỗ Túc, Gia Cát Lượng đã có biểu hiện kiệt suất, ông trù liệu chính xác, phân tích rõ ràng, khi cứng, khi mềm, khi thuận theo, khi khích tướng, cuối cùng hiệp trợ Tôn Quyền thắng được phái chủ hòa trong nước, xuất binh tiến hành một trận quyết chiến với Tào Tháo ở Xích Bích, có thể nói đã traọ chiếc chìa khóa mở cửa cho sự nghiệp của Lưu Bị được tiến triển.

	Trong cuộc chiến ở Xích Bích, thực tế là cuộc đối đầu giữa tập đoàn quân do Tào Tháo chỉ huy với thủy lục quân Đông Ngô do Chu Du chỉ huy. Đội quân của Tào Tháo bị chết trận và tan rã hơn mười vạn người mà bản thân Chu Du trong chiến dịch Giang Lăng sau đó cũng bị thương nặng, dẫn đến phải chết trong doanh trại, hai bên Tào Tháo và Tôn Quyền đều bị bại hoại, rốt cục người thu lợi chủ yếu lại là Lưu Bị. Tuy vậy Tào Nhân vẫn còn hùng cứ ở Tương Dương, Kinh Châu; Chu Du vẫn nắm giữ Giang Lăng, một vị trí quân sự quan trọng bên sông Trường Giang. Xong ở phía tây nam, một nửa phần Kinh Châu là ba quận Linh Lăng, Quế Dương, Trường Sa đã bị quân của Lưu Bị thừa cơ chiếm lấy, tạo ra đất sáng nghiệp trọng yếu của Lưu Bị, kế hoạch trên giấy “Long Trung Sách” của Gia Cát Lượng đã tiến được một bước có thể nói đã thành công được một nửa.

	Tuy ở giai đoạn này Gia Cát Lượng chưa tác động nhiều lắm đến sự sáng nghiệp của Lưu Bị, song việc phát triển sự nghiệp của Lưu Bị vẫn nằm trong quy hoạch phát triển của Gia Cát Lượng. Bước thứ hai của “Long Trung Sách” nhằm vào Ích Châu ở phía tây không lâu nữa cơ hội lại đến.

	Lưu Chương chiếm cứ Ích Châu, do nhiều năm bị quân Trương Lỗ ở Hán Trung phương bắc quấy nhiễu, thể theo những đề nghị của các trung thần Trương Tùng và Pháp Chính, đã chủ động mời quân của Lưu Bị đến giúp.

	Lưu Bị để Gia Cát Lượng hiệp trợ với Quan Vũ và Trương Phi trấn thủ Kinh Châu, tự mình dẫn theo Hoàng Trung tiến vào Ích Châu, còn có tổng tham mưu trứ danh Phượng Sồ tiên sinh. Trong đoàn xuất quân này, có thể thấy Lưu Bị rất xem trọng Gia Cát Lượng quân sư, tuy không xếp vào hàng mưu lược quân sự, song lại đặt ở vị trí điều hành hậu cần, giống như Tiêu Hà với Lưu Bang.

	Không bao lâu, các cánh quân của Lưu Bị tiến vào Ích Châu gặp phải sự cản trở của quân Lưu Chương, đội quân của Hoàng Trung tuy dũng mãnh thiện chiến, song lẽ thế đơn lực mỏng khó địch lại được đại quân bên Thục. Lưu Bị vội hạ lệnh Quan Vũ trấn thủ Kinh Châu, hai đội quân của Trương Phi và Triệu Vân theo hướng sông Nghi cùng tiến vào Ích Châu, hẹn hợp với quân Hoàng Trung cùng đánh Thành Đô.

	Tổng tham mưu trưởng của Trương Phi và Triệu Vân là Gia Cát Lượng, đây cũng là lần thứ nhất Gia Cát Lượng chủ động lãnh đạo việc quân. Do hai hộ tướng Trương Phi, Triệu Vân dốc lực phối hợp, khiến cuộc tấn công lần này gần như nắm chắc phần thắng.

	Không lâu, trong lần tiến đánh Thành Đô, Bàng Thống không may tử nạn, công việc tổng tham mưu chinh phạt đất Thục lại ở cả trong tay Gia Cát Lượng.

	Do thanh thế đội quân Lưu Bị rất lớn, lại có Pháp Chính trong đất Thục làm nội ứng, Lưu Chương thấy đại thế đã vỡ, bèn xin đầu hàng Lưu Bị. Bước thứ hai rất quan trọng mà “Long Trung Sách” đã hoạch định cũng là công việc khuếch triển rất khó khăn đã đạt được thành công thuận lợi.

	Sau khi chiếm được Ích Châu, không lâu Lưu Bị lại dẫn đội quân của Hoàng Trung và Triệu Vân, đánh vào đội quân Hạ Hầu Uyên được Tào Tháo phái đến Hán Trung, lấy sách lược đánh lâu dài, khiến đội quân viễn chinh của Tào Tháo không được viện trợ phải rút lui. Lưu Bị đã dần dần từng bước đi từ nhỏ đến lớn, sau tám năm Gia Cát Lượng hạ sơn giúp đỡ, đã tạo nên một kỳ tích là lập nên thế chân vạc chia ba thiên hạ (từ năm 207 đến 215). Trần Thọ trong Tam Quốc Chí viết rằng:

	“Lưu Bị sau khi bình định được Thành Đô, phong Gia Cát Lượng là Quân sư tướng quân, chức Tả tướng quân (đây là chức quan quan trọng của Lưu Bị) để trông coi việc lớn. Lưu Bị thường dẫn quân đội đi chinh chiến bên ngoài để Gia Cát Lượng ở Thành Đô trông coi triều chính, chẳng bao lâu khắp vùng Ích Châu đều dư thực dư binh”.

	Từ đó có thể thấy Gia Cát Lượng có tài điều hành và lập kế sách là một trợ thủ rất lớn bên cạnh Lưu Bị.'),
		('MS005', 'MC002', N'Hồi thứ nhất - Phần 2', N'4. Đời loạn trọng khoan dung, đời bình trọng sách vở.

	Cứ theo bình luận của Trần Thọ, Gia Cát Lượng đã có những thành công rất lớn, đáng kể là giai đoạn thứ hai, với vai trò một chính trị gia nổi tiếng. Khi đã có địa bàn của mình (ba quận Kinh Châu mượn của Tôn Quyền) Gia Cát Lượng đã dốc tâm điều hành công việc quản lý. Sách Tư trị thông giám có ghi rằng: “Gia Cát Lượng phụ tá Lưu Bị cai quản đất Thục pháp lệnh rất nghiêm, tầng lớp thế gia quan liêu đặc quyền ở Ích Châu chịu không nổi thường vẫn óan thán”.

	Một nhân vật tiêu biểu cho giới quyền quý cũng là một công thần của Lưu Bị khi vào Thục là Pháp Chính bèn khuyên Gia Cát Lượng rằng: “Cứ như Lưu Bang – Hán cao tổ xưa sau khi vào được Quan Trung phế bỏ pháp lệnh của đời Tần chỉ còn giữ lại ba chương quy định khiến cho dân Tần rất cảm kích bởi đức độ khoan dung. Nay tướng quân được ủy thác cai quản cả Ích Châu, trông coi quốc sự nên vỗ yên dân chúng, thi hành pháp luật nghiêm minh, theo kế phản khách ví chủ tướng chẳng nên làm ư? Hi vọng ông sẽ khoan dung hình phạt, nhẹ bớt lệnh cấm, để hợp với mong mỏi của dân đất Thục”.

	Gia Cát Lượng đáp rằng: “Tiên sinh chỉ biết một mà không biết hai, nước Tần thi hành chế độ hà khắc dẫn đến dân tình óan hận, nơi nơi phản loạn, thiên hạ bởi thế đất lở ngói vỡ. Lưu Chương vốn nhu nhược lại cố chấp nên chính trị ở đất Thục không phát huy được, chẳng nêu đức độ, hình phạt chẳng đủ, tầng lớp quan liêu thế tộc thừa cơ giành độc quyền, đạo quân – thần chẳng rõ ràng, nền luân lý xã hội cũng tan mất cả. Thực ra, đối với những kẻ quan liêu có đặc quyền này, nếu được sủng ái thái quá, lại làm cho họ không nghĩ đến trọng danh vị, lơi là trách nhiệm. Nếu ban ơn cho họ sau này ân huệ ít đi, họ sẽ óan thán, lại làm khó cho việc thực thi pháp lệnh của chính phủ. Nay ở đất Thục chứng bệnh lớn là ở đấy, nên ta mới nêu cao chánh pháp, để pháp lệnh có thể phát huy hiệu quả khiến nhân dân được bảo vệ chu đáo. Nếu hạn chế quyền thế của bọn quan liêu thế tộc, khiến họ phải gìn giữ tốt vị trí của mình. Như thế, làm quân, làm thần, làm dân đều phải có bổn phận, trên dưới có tiếp chế mới có thể khiến được người, cảm thụ được ân huệ của chính phủ”.

	Những lời này đã phân tích thấu triệt về việc vận dụng quyền lực trong xã hội. Vấn đề của nước Tần là pháp lệnh hà khắc, không hợp với hoàn cảnh hiện tại, nếu không nhận thức đúng, vấn đề quyền lực xã hội sẽ hỗn loạn trật tự. Vấn đề điều hành quốc gia, một điều rất quan trọng là sự nhận thức chung, để mọi người cùng thừa nhận vai trò quyền lực, vậy nên chính sách bao dung của Lưu Bang lại không phù hợp ở chỗ này hay chỗ khác.

	Với tình hình ở Ích Châu lúc ấy, Lưu Chương làm đổ vỡ chính sự, quyền lực không được tôn trọng, bọn quan liêu chấp pháp lười nhác hoành hành đặc quyền, pháp lệnh rối ren. Ở đây Gia Cát Lượng tất nhiên sẽ chú trọng sự nghiêm minh của hình pháp, đấy là nguyên nhân chủ yếu để đề cao uy tín của quyền lực.

	Nghiêm chỉnh mà nói xã hội đời Tần là loạn lạc, còn đất Thục mà Lưu Chương cai quản là một xã hội bê trễ. Loạn lạc thì quyền lực không được nhận thức đúng, đây dó tranh chấp liên tục không thôi, lúc này tự nhiên rất cần một chính sách bao dung. Còn xã hội bê trễ thì quyền lực không được coi trọng, thấy rõ mà làm trái, quan liêu lười nhác, dân chúng làm liều, như thế ắt phải chỉnh đốn lại bằng pháp luật nghiêm minh. Bởi vậy, nguyên tắc để vận dụng quyền lực một cách chính xác, đó là: “đời loạn trọng khoan dung, bê trễ trọng điều luật”.

	Thực ra, không thừa nhận và không tôn trọng quyền lực là vấn đề thường tồn tại. Đối với người cầm quyền, rất nên hiểu rõ chỗ nào thì cần khoan dung, chỗ nào thì cần dùng luật. Về phương diện này mà nói, Gia Cát Lượng đã lý giải rõ ràng với Pháp Chính vậy.

	5. Thành Bạch Đế gửi con, bày tỏ đạo quân thần

	Sau khi Tào Tháo tự phong làm Ngụy Vương, Lưu Bị cũng tự phong là Hán Trung Vương. Đến khi Tào Phi cướp ngôi nhà Hán, Lưu Bị nghe theo lời đề nghị của Gia Cát Lượng lập ra nhà Thục Hán lên ngôi đế vị, lấy kế tục nhà Hán làm lễ chánh thống. Năm Chương Vũ thứ 2 (Niên hiệu của Lưu Bị), Lưu Bị lấy cớ báo thù cho Quan Vũ, cử binh đánh Đông Ngô, song bị tướng Ngô là Lục Tốn đánh bại ở Tỉ Qui, bi phẫn mà chết (tháng 4 năm Chương Vũ thứ 3). Trước lúc lâm chung, có cho gọi Gia Cát Lượng đến Bạch Đế thành dặn dò việc mai sau.

	“Khanh mới thực gấp mười Tào Phi, tất có thể giữ yên được nước, ổn định đại sự, nếu có thể phụ giúp cô tử thì giúp, nếu như nó bất tài, khanh hãy tự nắm lấy cả quyền hành”.

	Gia Cát Lượng nghe vậy thất kinh, dàn giụa nước mắt quì xuống mà tâu rằng: “Thần xin dốc sức làm tay chân, theo đúng lẽ trung trinh nguyện chết không đổi vậy”.

	Lưu Bị liền cho gọi Thái tử Lưu Thiện, dậy rằng: “Ngươi phải cùng với tể tướng (chỉ Gia Cát Lượng) điều hành công việc quốc gia này, phải tôn trọng tể tướng cũng như cha, cha phải đạo làm con”.

	Không ít sử gia cho rằng, Lưu Bị khi ở cung Vĩnh An, Thành Bạch Đế ủy thác con cho Khổng Minh, nói về đoạn đối thoại này, ít nhiều cho rằng đó là phép “khích tướng” của người làm chính trị, lại cũng nói rằng, cốt để cho Gia Cát Lượng không dám lộng quyền, mà phải dốc lòng phụ chánh Lưu Thiện. Xét ra, đoạn này nói về đạo lý, nếu xét kĩ tình thế nước Thục lúc bấy giờ, sự đồng nhất giữa Lưu Bị và Gia Cát Lượng, thấy rõ được là, nếu có ý ngờ, tức là lấy bụng tiểu nhân đo lòng quân tử mà thôi.

	Lưu Bị trước lúc lâm chung, với Gia Cát Lượng đã có mười sáu năm tình nghĩa thắm thiết, con người Gia Cát Lượng ra sao ông đã quá rõ ràng. Huống như các quan văn võ nước Thục bấy giờ, đều tôn sùng Lưu Bị, nếu như không được Lưu Bị ủy thác, Gia Cát Lượng muốn làm tới cũng không nhận được ủng hộ của số đông. Lưu Bị đối với việc này cũng chẳng bận tâm lắm. Hơn nữa, lúc đó lại có cả đại thần Lý Nghiêm và Triệu Vân bên cạnh; nếu như Gia Cát Lượng có muốn tiếm quyền chẳng phải đã có một “cây gậy pháp lý” trong tay ư?

	Trái lại, Lưu Bị đã quá hiểu rõ con mình một cách tường tận. Chúng ta có thể tin được rằng khi ông bảo Gia Cát Lượng tùy nghi đoạt quyền, ít nhiều đã thấy trước vấn đề, muốn để Gia Cát Lượng có đủ cơ sở pháp lý, đề có thể ứng biến tùy thời. Trần Thọ trong Tam quốc chí đoạn nói về tiên chủ có bình rằng: “Tiên chủ là người khoan dung đại độ, trọng hiền đãi sĩ, có phong độ như Hán cao tổ Lưu Bang”.

	Người có khí chất anh hùng, khi gửi con cho Gia Cát Lượng lòng thanh thản không ngờ vực tỏ rõ đạo quân thần xưa nay hiếm vậy!

	Xét thấy, sự bận tâm của Lưu Bị chẳng phải Gia Cát Lượng có đoạt quyền hay không, mà là Lưu Thiện có đảm đương được việc nước hay không. Sau này Gia Cát Lượng có viết trong Xuất Sư Biểu rằng:

	“Tiên đế biết thần cẩn thận, trước lúc lâm chung có uỷ thác việc đại sự, kể từ lúc phụng mệnh đến nay, sớm tối lo lắng, sợ không xứng được sự ủy thác, phụ lòng mong mỏi của Tiên đế vậy”.

	Thật là câu nói từ gan ruột! Giữa hai vị quân thần cách nhau hai mươi tuổi này, đã để lại một hình ảnh đẹp trong sử sách Trung Quốc. Lưu Bị mừng như cá gặp nước, khi gặp Gia Cát Lượng, đấy không phải là một câu sáo ngữ mà là sự tán thưởng tri âm tri kỉ.

	Song, Gia Cát Lượng đơn độc một mình nắm trọn quyền điều hành nước Thục, rất cần một tiếng nói ủng hộ mạnh mẽ. Sự uỷ thác của Lưu Bị trước lúc lâm chung là một tiếng nói như thế.

	6. “Tác phẩm” của tổng tư lệnh quân viễn chinh: Bình loạn Nam phương.

	Sau khi Lưu Bị từ trần, hoàng thái tử Lưu Thiện mười bảy tuổi lên kế vị đổi niên hiệu là Kiến Hưng. Năm Kiến Hưng nguyên niên (là năm 223 sau Công Nguyên) phong Gia Cát Lượng là Vũ hương hầu, khai phủ trị sự không lâu lại phong thêm chức Ích Châu mục, trở thành người nắm quyền hành tối cao về hành chính ở nước Thục. Tam quốc chí có ghi: “Mọi việc chánh sự lớn bé đều ở tay Gia Cát Lượng”. Lưu Thiện còn trẻ tuổi thiếu năng lực và kinh nghiệm nên mọi việc đều phó thác cho quan tể tướng. Năm đó, Gia Cát Lượng bốn mươi ba tuổi.

	Sau khi nắm được thực quyền, Gia Cát Lượng chú trọng việc điều hành chính sự, nỗ lực đề bạt nhân tài, tạo ra những quan chức ưu tú. Mặt khác, khuyến khích phát triển nông nghiệp cùng nuôi tằm dệt vải, thúc đẩy kinh tế dân sinh và chuẩn bị thực lực chiến đấu.

	Về ngoại giao ông vẫn thực hiện theo phương châm quy hoạch của “Long Trung Sách”, liên kết Đông Ngô để cùng chống lại Tào Ngụy. Lưu Bị sau khi bị bại trận ở Tỉ Quị, cũng hiểu ra rằng mình đã mắc một sai lầm chiến lược quan trọng, bèn chủ động với Đông Ngô cùng hòa đàm. Sau khi Gia Cát Lượng nắm chính sự, lại phái nhà ngoại giao kiệt suất là Đặng Chi, đến nước Ngô ký kết hòa ước tạo ra khối đồng minh lâu dài. Suốt thời gian Gia Cát Lượng còn hiện diện, Thục Ngô tuy khi nóng khi lạnh, song nhìn chung không phát sinh xung đột quân sự nữa, để Gia Cát Lượng có chỗ dựa, thực hiện mục tiêu quan trọng của “Long Trung Sách” là: Đánh bại Tào Ngụy, khôi phục nhà Hán. Song, vừa tránh khỏi một cuộc chiến, nguy cơ lại đến từ các quận miền nam Ích Châu. Sau khi Lưu Bị từ trần không lâu, các quận phía nam thừa cơ làm phản loạn, Gia Cát Lượng đang khi quốc tang không tiện xuất binh đành tạm cho qua.

	Năm Kiến Hưng thứ 3, quan hệ vối Đông Ngô sớm được ổn định, Gia Cát Lượng lệnh cho các đạo quân chủ lực của Mã Siêu, Triệu Vân, nghiêm cẩn đề phòng sự quấy rối của quân đội phía bắc, quyết định rằng: muốn vững ngoài trước phải yên trong, tự mình thống lĩnh đại quân nam chinh để bình định lại phía nam Ích Châu đang phản loạn.

	Dẫu rằng có rất nhiều bá quan văn võ đã can gián Gia Cát Lượng thân chinh đánh dẹp, bởi phương nam địa thế rất hiểm trở, lắm nguy cơ, chẳng bằng phái một viên đại tướng đi trấn áp là đủ. Song, Gia Cát Lượng kiên quyết tự mình xuất chinh, kết hợp nhân tố chính trị và quân sự nếu không có mặt trực tiếp giải quyết sẽ ít kết quả.

	Trước lúc nam chinh Gia Cát Lượng từng hỏi viên tổng tham mưu Mã Tắc về sách lược chủ yếu trong việc bình định phương nam. Mã Tắc thưa rằng: “Cần lấy công tâm làm đầu”. Gia Cát Lượng rất tán thưởng, do đấy có thể thấy rằng lần này trong quan điểm quân sự của Gia Cát Lượng nổi lên vấn đề chính trị kết hợp với quân sự, có thể không đánh mà kẻ địch cũng tan vậy. Những quan điểm này cùng đồng nhất với chủ nghĩa hoàn mỹ và nguyên tắc giao chiến cẩn thận mà ông sẽ vận dụng trong chiến tranh bắc phạt sau này. Tháng ba năm thứ 3 niên hiệu Kiến Hưng, Gia Cát Lượng tự mình dẫn đại quân vượt qua Trường Giang xuống miền nam Tứ Xuyên, thâm nhập vào vùng Vân Nam. Tháng Năm, vượt qua sông Lô Thủy đánh thẳng vào đại bản doanh của phản quân; bởi đã phát huy tốt nguyên tắc chính trị tác chiến, Gia Cát Lượng không thực hiện sự nghiêm khắc luật pháp như trước, trái lại vận dụng một chính sách khoan dung vô tiền khoáng hậu trong lịch sử Trung Quốc.

	Sau khi đã bắt được nhân vật chính của quân phản loạn là Mạnh Hoạch, ông lại dẫn hắn tham quan trận địa quân Thục để thấy thế nào là lực lượng hùng hậu, rồi lập tức trả tự do cho hắn, hẹn sẽ giao đấu nữa để phân rõ thắng bại.

	Cuộc chiến này cho thấy những hành vi chiến tranh vốn tàn khốc có thể chuyển hóa thành một cuộc giao đấu trí tuệ chẳng những có thể giải tỏa được tâm lý thù hận của đối phương, lại khiến kẻ địch qua cuộc đấu trí ấy mà sợ hãi, dẫn đến sự đầu hàng triệt để. Có thể nói nghệ thuật chính trị tác chiến cao độ của Gia Cát Lượng ở đây đã biểu lộ một cách hoàn hảo; dựa vào truyền thuyết lịch sử, Gia Cát Lượng từng bẩy lần bắt được Mạnh Hoạch lại phóng thích cả bẩy lần. Hình thái chiến tranh thuyết pháp này, khiến người ta khó hình dung nổi, song cuối cùng Mạnh Hoạch tâm phục, khẩu phục, phải quì lạy giữa trận, cất lời thề rằng không bao giờ dám làm phản nữa, hoàn toàn chịu thần phục dưới sức mạnh của nước Thục.

	Sau khi bình định phản loạn phương Nam, Gia Cát Lượng lại rút toàn bộ quân đội trở về, lệnh cho Mạnh Hoạch cùng gia tộc tiếp tục điều hành phương Nam, rồi toàn quân ca khúc khải hoàn trở về kinh thành. Đây là thái độ khoan dung và tin cậy khiến cho các dân tộc dị chủng văn hóa phương Nam đã triệt để phục tùng. Suốt thời thuộc Hán, các quận miền Nam chẳng những không dám tạo phản, lại còn cung ứng nhiều vật tư lương thực giúp Gia Cát Lượng có thêm lực lượng đầy đủ tiến hành cuộc chiến trường kỳ với phương Bắc. Mạnh Hoạch sau này còn giúp nhà Thục Hán rất nhiều công việc khác.

	Gia Cát Lượng ở đây đã thấy rất rõ quyền lực chung không được thừa nhận và không được tôn trọng, có chính sách khoan dung hoặc nghiêm khắc để giải quyết vấn đề rõ ràng là một người điều hành chính sự rất có trí tuệ trong lịch sử Trung Quốc.

	7. Theo đuổi đến cùng nguyên tắc quân sự cẩn thận

	Ở đoạn văn cuối cùng của bản viết “Long Trung Sách” Gia Cát Lượng muốn bày tỏ cùng với Lưu Bị rằng: “Một khi đại thế thiên hạ có biến nên sai một viên thượng tướng dẫn binh mã Kinh Châu tiến lên phía Bắc trực tiếp đánh vào Lạc Dương, tướng quân lại dẫn đạo quân Ích Châu theo đường Tần Xuyên tiến đánh Quan Trung, thì còn sợ gì trăm họ chẳng mang giỏ cơm bầu nước ra nghênh đón tướng quân? Nếu như cứ theo kế hoạch nàv mà làm, tướng quân sẽ tạo dựng được nghiệp bá, nhà Hán nhất định sẽ trung hưng được”.

	Trong “Xuất Sư Biểu” Gia Cát Lượng lại trình bày rõ ý kiến của mình với Lưu Thiện:

	“Nay phương Nam đã bình định, binh giáp đã đầy đủ đáng khích lệ ba quân; bắc định Trung Nguyên xin đem hết lòng khuyến mã trừ sạch gian ác phục hưng triều Hán về lại cố đô, như vậy là thần báo đáp được tiên đế, mà trúng với chức phận dưới bệ rồng vậy”.

	Từ đó thấy rằng Bắc phạt Trung Nguyên phục hưng triều Hán là một chí hướng đeo đẳng Gia Cát Lượng suốt một đời. Khéo thu thập chỉnh lý tin tức tình báo; Gia Cát Lượng đã dày công chuẩn bị, mải mê với khôi phục “khí độ vương triều”, đây cũng là vấn đề quan tâm của nhiều người có tâm huyết. Đến cả những nhân vật thường gần gũi vói Tào Tháo như Tuân Úc, Thôi Diễm, Mao Giới cũng đều bởi muốn gìn giữ nhà Hán, cùng với Tào Tháo đối đầu mà dẫn đến bỏ mình hoặc chịu một số mệnh không sáng sủa. (Hai bên ở hai đầu trận tuyến mà đều vì nhà Hán vậy).

	Trong cuốn Tư Mạc, Chuyên Chương cho chúng ta thấy nguồn gốc loại tư tưởng này, bao quát Gia Cát Lượng và những người cùng thời. Gia Cát Lượng kiên trì chiến lược liên Ngô chống Tào mà không lượng sức mình Bắc phạt Trung Nguyên, cuối cùng phải lâm bệnh bỏ mình giữa quân doanh ở gò Ngũ Trượng, đấy cũng là lý tưởng thời đại của những phần tử trí thức lúc đó.

	Song Gia Cát Lượng vốn là người theo đuổi chủ nghĩa thực tế, trong cuộc chiến có thể nói lấy trứng trọi với đá này, ông giữ một thái độ luôn luôn thận trọng.

	Năm Kiến Hưng thứ 5, Gia Cát Lượng nhân khi Ngụy chủ Tào Phi vừa từ trần, Tào Duệ vừa mới lên ngôi, tình hình chính trị nước Ngụy đang rối ren quyết định tiến hành Bắc phạt để mở rộng địa bàn nước Thục, giúp cuộc chiến tranh trường kỳ có thêm uy thế. Sau khi đề xuất tờ sớ “Xuất Sư Biểu” với hậu chủ Lưu Thiện, Gia Cát Lượng dẫn đại quân tiến hành cuộc Bắc phạt lần thứ nhất.

	Từ năm thứ 5 Kiến Hưng đến năm thứ 12, suốt thời gian bảy năm chính sử còn ghi lại, Gia Cát Lượng trước sau tiến hành bốn cuộc chiến Bắc phạt. Tuy trong thời gian này có thu được một số thành công đáng kể, song cuối cùng đành phải rút về, ở đây có sự chênh lệch thực lực rất lớn, song Gia Cát Lượng lại là người quá thận trọng không dám mạo hiểm, mà trong binh pháp đôi khi mạo hiểm lại là cần thiết. Trần Thọ khi bình phẩm phần Gia Cát Lượng truyện có viết: “Nhiều năm huy động sức dân luôn đánh không thắng, nói về sự tháo vát ứng biến, đó chẳng phải là sở trường của ông vậy”. Điều đó có thể có lý.

	Trong cuộc Bắc phạt lần thứ nhất, tại hội nghị quân sự trước trận đánh, hổ tướng Ngụy Diên có đề xuất một chiến thuật đột kích táo bạo, dẫn đại quân ra Tà Cốc, trực tiếp đánh thẳng vào Trường An tranh thủ khi Ngụy quốc còn chưa kịp phản ứng, nhanh chóng chiếm lấy Quan Trung.

	Lúc đó quan trấn thủ Trường An là Hạ Hầu Mậu, con rể của Tào Tháo, thuộc loại con ông cháu cha thiếu kinh nghiệm tác chiến, nếu đột nhiên tiến đánh, có thể y sẽ kinh hoàng tháo chạy, bởi vậy kế hoạch này rất có khả năng thực hiện.

	Song, chiến cuộc này cũng không khác gì người dùng sức để thi vụt bóng gậy vào đích, tuy có khả năng song cũng chỉ là phỏng chừng. Đội quân đơn lẻ thâm nhập vào Quan Trung, nếu gặp phải đại quân Ngụy quốc triệt lộ ở tuyến sau sẽ bị khốn đốn. Bởi vậy với Gia Cát Lượng là một người theo nguyên tắc cẩn trọng, chẳng thể chấp thuận chiến thuật bạo phổi này.

	Chiến thuật mà Gia Cát Lượng tâm đắc, là vận dụng sách lược đánh ngắn ngày giành thắng lợi nhanh, hi vọng đánh dần dần để thắng lợi, tuy phải trả giá đắt và tốn thời gian song có thể tránh được mạo hiểm cùng thất bại.')

insert into NOIDUNGSACH values 
	('MS006', 'MC001', N'Mẹ kế', N'Tôi ôm cặp bước vào nhà đã nghe tiếng mẹ tôi quát:

	– Giống con gái mẹ mày vừa vừa vậy, không ai chịu nổi đâu.

	Có tiếng chị Liễu phân bua yếu ớt:

	– Thưa dì, không phải lỗi tại con. Xin dì đừng nói đến mẹ con tội nghiệp.

	Tiếng mẹ tôi cười gằn:

	– Giỏi cãi, sao không chết phứt cho rảnh mắt không biết.

	Chị Liễu khóc rấm rức. Mẹ tôi ném mạnh một cái gì đó rồi hậm hực đi lên nhà trên. Tôi nép vội vào cửa phòng, chờ mẹ đi qua mới cất cặp, thay vội chiếc áo dài máng lên móc rồi chạy xuống bếp với chị Liễu.

	Tôi thấy chị đang ngồi khóc cạnh thau quần áo, tôi đến bên chị, hỏi nhỏ:

	– Sao vậy hả chị?

	Nước mắt còn đọng trên bờ mi, giọng chị tôi nghèn nghẹn:

	– Có gì đâu em.

	Tôi biết chị lại dấu tôi như nhiều lần bị đánh, bị mắng chị vẫn dấu như thế. Tôi lắc đầu:

	– Chị dấu em, em biết mẹ mới rầy chị nè.

	Chị Liễu gượng cười nói lảng:

	– Em mới đi học về hả? Áo dài đâu đưa chị giặt luôn.

	Tôi nhất quyết lắc đầu từ chối sự săn sóc của chị!

	– Em lớn rồi, chị để em làm cho quen, chị còn cả đống đồ kia kìa.

	Chị Liễu nhìn tôi bằng cặp mắt tràn thương mến:

	– Giặt thêm cho em cái áo dài có sao? Ngoan, không chị ghét.

	Tôi biết chị Liễu thương tôi, thương nhất nhà dù chị có đến bốn đứa em, cùng cha khác mẹ, nghĩa là em ruột tôi. Tôi biết con Lan ghét chị Liễu như mẹ tôi vậy. Nó không bỏ lỡ lỗi lầm nhỏ nhặt nào của chị để mét lại với mẹ tôi.

	Mẹ tôi, thì người chỉ chờ có dịp để hành hạ, chưởi mắng chị Liễu, đứa con riêng của chồng và cũng là cái gai trước mắt bà.

	Tôi không hiểu tại sao mẹ tôi ghét chị Liễu. Theo tôi thì chị rất dễ thương, hiền, ngoan, chị lại giỏi dắn trong việc nội trợ. Thế mà mẹ tôi cứ khư khư xem chị như một kẻ thù.

	Ở lứa tuổi 17 như tôi, tôi không còn quá khờ khạo để không hiểu nguyên nhân làm mẹ tôi ghét chị Liễu, nhưng tôi thấy nguyên nhân ấy tầm thường quá, có gì đáng ghét ở một đứa con chồng?

	Theo chỗ tôi hiểu, chị tôi mất mẹ năm lên 3 tuổi. Ba tôi ở vậy được hơn hai năm thì tục huyền với mẹ tôi bây giờ. Định mệnh cuộc sống của tôi bắt đầu từ đấy.

	Ba tôi thì bận rộn công việc ít khi ở nhà. Tất cả quyền hành nằm cả trong tay mẹ tôi. Nhiều khi tôi cảm thấy bực mình về sự nhu nhược của ba tôi, ông tỏ ra quá bất công với chị Liễu để chiều ý mẹ tôi. Bao giờ, theo lời mẹ tôi kể lại, thì phần lỗi cũng hoàn toàn trút lên đầu chị Liễu. Sự thật, có hay không, chị Liễu cũng chỉ biết lặng im, cắn răng chịu đựng.

	Bất nhẫn về thái độ của mẹ, tôi không biết làm gì hơn là an ủi, dỗ dành chị Liễu. Những lúc đó chị tôi khóc trên vai tôi như một đứa bé cần sự che chở của người lớn.

	Chị Liễu thường kể cho tôi nghe rằng mẹ chị hồi đó cưng chị lắm, cũng như mẹ tôi cưng tôi bây giờ vậy. Cả ba nữa, ba cũng yêu thương nâng niu chị từng chút chứ không phải gắt gỏng, lạnh lùng như bây giờ đâu.

	Mỗi khi nhắc đến người mẹ quá cố, chị Liễu thường không cầm được nước mắt. Tôi không biết nói sao để an ủi chị. Tôi biết chị buồn mẹ tôi nhiều, và càng tủi thân hơn khi nghĩ đến tình thương đã mất. Tôi không thấy mẹ tôi đáng ghét ở điểm nào, trên phương diện khách quan mà nói: người xinh đẹp theo lứa tuổi 40, nội trợ giỏi, đảm đang thương yêu và lo lắng cho con cái hết lòng, chỉ phải cái tội là ghét cay ghét đắng đứa con chồng.

	Tôi còn nhớ những trận đòn chị Liễu phải chịu ngày tôi còn nhỏ. Chị Liễu hơn tôi 5 tuổi, tức là khi tôi lên ba, chị đã lên tám tuổi. Mẹ tôi bắt chị theo “chăn” tôi. Mỗi khi tôi không bằng lòng cái gì, ré lên khóc là y như chị Liễu ăn đòn, mẹ tôi đánh mà không cần biết vì sao.

	Đến khi những đứa em tôi lần lượt ra đời, chị Liễu càng khốn khổ hơn. Chị làm “vú em” hết đứa này đến đứa khác. Chị cũng được đi học, nhưng công việc nhà thường không cho phép chị học bài, thế nên khi thi trung học đệ nhất cấp, viện cớ chị không lo học hành để thi hỏng, mẹ tôi bắt chị nghỉ học luôn. Năm đó chị 18 tuổi và tôi được 13 tuổi.

	Chị Liễu yêu thương tôi vô cùng. Chị chăm sóc tôi từ bộ quần áo, đầu tóc. Vẫn biết đó là công việc mẹ tôi giao cho chị, nhưng tôi biết chị săn sóc tôi vì tình thương.

	Mái tóc của tôi để ngang vai, dầy và đen tuyền. Chị Liễu hay gỡ tóc cho tôi và đánh thành hai cái bím lủng lẳng. Có dạo thấy các bạn đi cắt tóc kiểu con trai nhiều, coi cũng ngồ ngộ, tôi háo hức đòi đi, nhưng chị tôi dịu dàng khuyên:

	– Đừng cắt tóc con trai Thụy à, chị thấy không đẹp đâu. Gương mặt em để tóc xõa dài dễ thương lắm. Mình là con gái, giữ lấy vẻ thùy mị của mái tóc chứ bắt chước con trai làm chi.

	Nghe chị nói có lý, tôi thôi không đòi đi cắt tóc nữa. Và chị càng chăm sóc mái tóc tôi nhiều hơn.

	Tôi 17 tuổi, nhưng mẹ tôi vẫn coi tôi như một đứa bé con cần được chăm sóc từng ly từng tí, trong khi lúc ở tuổi tôi, chị Liễu đã phải tự mình đảm đang hết mọi việc trong nhà.

	Sự bất nhẫn về tình thương chênh lệch làm tôi vơi đi phần nào sung sướng. Đáng lẽ ở vào cương vị như tôi: một đứa con gái được mẹ che chở yêu thương, nuông chiều, được hưởng một đời sống vật chất sung túc, tôi phải mãn nguyện lắm. Nhưng sự đối xử của mẹ tôi đối với chị Liễu đã làm tôi thường xuyên ray rứt, niềm vui vì thế không trọn vẹn.

	Tôi nghĩ, hoặc là mẹ tôi khoan dung một chút, hoặc là ba tôi cứng rắn với vợ một chút, chắc chắn chúng tôi không bị sự bất công làm cách biệt.

	Ít khi mẹ tôi rầy mắng mà chị dám trả lời lại, trừ những lúc đụng chạm đến mẹ chị như hôm nay, có lẽ sự tủi thân làm chị liều lĩnh.

	Tôi miên man trong những ý nghĩ, tiếng chị Liễu đưa tôi về thực tại:

	– Bữa nay Thụy về hơi sớm hả?

	Tôi gật đầu:

	– Dạ, em nghỉ giờ cuối.

	Chị Liễu vừa vò áo quần vừa hỏi:

	– Học vui không em? Làm bài được chứ?

	Tôi đem chuyện ở trường, ở lớp kể lại chị nghe. Hai chị em tôi cười vui vẻ. Chị Liễu như tạm quên những bất công đã, đang và sẽ bủa vây lấy đời sống của chị.

	***

	Tôi thử chiếc áo dài mới, ngắm nghía trong gương. Mẹ tôi cười:

	– Màu áo này con mặc đẹp đấy. Da con trắng, mặc màu xanh nổi lắm.

	Mẹ tôi nghiêng người ngắm tôi, bàn tay bà nhè nhẹ vuốt tóc tôi âu yếm:

	– Con mẹ xinh lắm, lớn rồi nghe không cô.

	Tôi nũng nịu nhìn mẹ. Ánh mắt bà thật âu yếm. Sự sung sướng tràn ngập trong tôi. Tôi ngồi xuống cạnh mẹ tôi trên chiếc canapé màu đỏ hỏi mẹ:

	– Năm mẹ bằng tuổi con chắc mẹ xinh hơn con bây giờ nhiều phải không mẹ?

	Mẹ tôi lắc đầu:

	– Mẹ cũng như con vậy, có điều hồi đó ông bà ngoại con nghiêm khắc nên không sắm sửa cho mẹ như mẹ sắm cho con bây giờ.

	Tôi vít cổ mẹ xuống hôn đánh “chụt” vào trán bà:

	– Con thấy bây giờ mẹ đẹp quá, y như lúc con còn bé tí. Bao giờ mẹ cũng đẹp cả.

	Chợt có dáng chị Liễu đi ngang, tôi thấy ánh mắt chị thoáng nhìn cảnh âu yếm của mẹ con tôi với đôi mắt buồn rũ rượi. Tôi thấy thương chị hơn bao giờ hết. Thấy mẹ đang vui, tôi gợi chuyện về chị Liễu:

	– Mẹ nè!

	– Gì con.

	– Sáng nay mẹ không đi chợ sao?

	Mẹ tôi lắc đầu:

	– Sáng nay mẹ hơi nhức đầu, sai con Liễu nó đi rồi.

	Tôi nói như một sự vô tình:

	– Chị Liễu tội chứ mẹ nhỉ?

	Ánh mắt mẹ tôi tỏ vẻ không bằng lòng.

	– Tại sao con nói thế?

	Tôi vẫn vờ như không quan tâm mà chỉ là một nhận xét rất khách quan:

	– Thì con thấy như vậy thôi. Chị ấy hiền và vất vả nhiều.

	Tôi cố làm mẹ tôi chú ý hơn đến chị Liễu bằng thiện cảm:

	– Chị Liễu thương con lắm mẹ ạ.

	Mẹ tôi bĩu môi:

	– Thương gì mà thương, con. Chỉ được cái nước làm màu vậy thôi. Nó ăn cơm của mình thì phải săn sóc con chứ, không lẽ nuôi cơm nó để thờ sao.

	Tôi thấy bất nhẫn trước nhận xét quá đáng của mẹ. Ba tôi cũng là ba chị Liễu. Ba chúng tôi đi làm kiếm tiền về nuôi lũ con, trong số đó có chị tôi nữa, vậy mà mẹ tôi nói y như chị là một người làm công, không hơn không kém.

	Mẹ tôi thương tôi vô cùng. Người có thể chiều tôi tất cả mọi việc, trừ việc tôi đòi hỏi một sự công bằng cho chị Liễu. Có lẽ ấn tượng không đẹp giữa “mẹ ghẻ con chồng” đã quá sâu đậm trong đầu óc bà. Chính chị Liễu cũng hiểu tôi cố gắng trong việc xoay chiều cảm nghĩ của mẹ tôi về chị, nhưng không thành công. Chị thường nói với tôi:

	– Chị biết Thụy thương chị nhiều, Thụy muốn má cũng thương chị. Nhưng má không muốn thế thì em đừng nên nói nhiều rồi má sẽ nghĩ lầm rằng chị xúi biểu em, lại ghét chị thêm thì khổ.

	Tôi biết chị Liễu đã nói đúng, nhưng tôi vẫn rình chờ cơ hội để “tấn công” vào tình cảm mẹ tôi, tôi muốn thấy chị tôi sống êm đềm trong tình thương như chúng tôi đang sống.

	Tôi chợt nói với mẹ bằng một vẻ… ngây thơ nhất đời:

	– Mẹ ơi, sao mẹ ghét chị Liễu dữ vậy?

	Dường như một thoáng bàng hoàng nào đó vừa đi qua tầm mắt mẹ tôi. Người tin rằng tôi biết người ghét chị Liễu, nhưng người không tin rằng tôi dám nói lên nhận xét đó một cách trắng trợn như vậy. Mẹ tôi hỏi:

	– Sao con nghĩ thế?

	Tôi vẫn cố đóng trọn vai trò… trẻ con vô tình:

	– Thì con thấy vậy nên hỏi mẹ.

	Mẹ tôi thoáng nghi ngờ:

	– Ai nói với con vậy Thụy? Con Liễu phải không?

	Tôi lắc đầu lia lịa:

	– Đâu có mẹ. Chị ấy đâu nói gì với con.

	Mẹ tôi căn dặn:

	– Con còn nhỏ, cứ lo học đi, đừng để ý chuyện người lớn nghe chưa. Nghe nó nói rồi đâm ra oán cha ghét mẹ không chừng.

	Sợ mẹ tôi lại trút cơn giận lên đầu chị Liễu, tôi nói lảng đi:

	– Mẹ nè, bữa nào mẹ dẫn con đi chợ nghe mẹ.

	Mẹ tôi vui trở lại:

	– Con muốn sắm gì? Robe hay áo dài.

	Tôi nũng nịu lắc đầu:

	– Đôi găng tay của con sờn rồi, con muốn sắm đôi khác.

	Mẹ tôi đồng ý ngay:

	– Ừ, được, để mẹ đưa con vào Tax chọn.

	– Ở chợ Bến Thành thiếu gì mà phải vào Tax hả mẹ?

	Mẹ tôi âu yếm:

	– Mẹ biết, nhưng ở Tax đồ ngoại quốc tốt hơn.

	Chạnh nghĩ tới chị Liễu suốt năm chỉ có ba mớ đồ nội hóa rẻ tiền, nhưng tôi không dám nói thẳng ý nghĩ đó với mẹ. Tôi sợ chú ý dồn dập đến chị quá làm mẹ tôi nghi ngờ chị xúi biểu nên thôi.'),
		('MS006', 'MC002', N'Bạn bè', N'Tôi vừa đến cửa trường đã gặp ngay Sâm và Châu. Hai con bé kéo tay tôi đến bên gốc cây phượng lớn. Cả ba đứa cùng ngồi xuống trên những cái cặp da mang đầy vẻ chịu đựng. Sâm nói trước:

	– Tụi mày thuộc hết bài chưa?

	Châu lắc đầu, nhăn mặt:

	– Bài khó bỏ xừ đi. Mấy cái công thức hóa học mà nhồi hoài không vô.

	– Tại mày không chịu học cho kỹ chứ!

	Sâm chu môi:

	– Nói vậy chắc mày thuộc?

	– Ơ… hơ… Tôi bị hỏi đột ngột, ngẩn tò te ra nhìn chúng nó.

	Châu xoa hai tay vào nhau:

	– Vậy là mày suya há? Lát nữa nhắc nghe “cưng”.

	Vừa lúc đó bộ ba Liên, Nga, Nhung ào đến. Nga oang oang nói:

	– Hỉ tín, bà con cô bác ơi, hỉ tín.

	Cả ba đứa tôi cùng nhỏm dậy hỏi dồn:

	– Gì vậy chúng mày? Khiếp, long trọng quá làm tao… dựng cả tóc gáy.

	Châu cười sau câu nói, nhưng Nhung không cười:

	– Con Nga nói thật mà.

	Sâm gật:

	– Ừ, thì thật, chứ tao có bảo nó nói dối đâu. Nhưng… thật cái gì đã chứ? Gớm úp mở hoài sốt cả ruột…

	Như sợ các bạn nói tranh, Nga nói liền:

	– Nghỉ, hôm nay nghỉ.

	Cả bọn ba đứa tôi há hốc miệng, mở to mắt ra mà nhìn nó. Nga giải thích:

	– Ông Lý-Hóa bị xe đụng, lấy ai mà dạy.

	Sâm reo lên:

	– Nhất, thế thì nhất… nhưng… có thật không đó “bà”? Ai nói cho “bà” biết tin đó vậy? Để rồi đúng lúc mình đang hí ha hí hởn thì “lão” ấy xuất hiện… thấy mồ.

	Tôi nhìn Sâm:

	– Mày lại nghĩ ác rồi. Thầy mình mà mày trù ẻo ổng như vậy tội chết. Ông ấy không bị tai nạn thì mừng chứ.

	Sâm nhún vai:

	– Tao chả mừng. Bài tao không thuộc, ngán thấy ông ấy lắm.

	Nga tỏ vẻ đồng ý với Sâm:

	– Tao cũng vậy. Thôi kệ ổng. Mình không học là sướng. Đi về, tao ghé chợ Sàigon coi vải chơi.

	Sâm tán đồng ngay:

	– Cho tao đi với.

	– Ừ, hai đứa mình đi

	Còn lại mấy đứa đứng nhìn nhau. Châu hỏi tôi:

	– Thụy về hả?

	Tôi gật đầu:

	– Mình về. Mấy bồ đi đâu không?

	Châu nói:

	– Mình đề nghị thế này, cả bọn kéo nhau lại nhà thầy Lý-Hóa thăm ổng một chút cho có tình.

	Tôi mỉm cười:

	– Đi thì đi. Nhưng một mình Châu vào thôi nghe, tụi mình đứng ngoài cửa hết.

	Châu hiểu ý, đỏ mặt:

	– Thụy kỳ quá. Đi cả bọn thì vô hết chứ sao lại chỉ có mình tui vô coi sao được.

	Chúng tôi nheo mắt nhìn nhau, thông cảm câu đùa cợt vừa rồi. Sở dĩ tôi bảo Châu vào thăm thầy một mình là vì thường khi, nó vẫn nói với chúng tôi là nó thích cặp mắt của thầy Huy lắm, “cặp mắt buồn đăm chiêu như một nhà thơ”. Tôi không biết một “nhà thơ” đôi mắt như thế nào, nhưng Châu thì quả quyết “phải có đôi mắt đẹp như thầy Huy thì mới làm thơ được”.

	Chúng tôi hai đứa lên một chiếc Honda nhắm hướng Vườn Chuối trực chỉ. Đi ngang chợ, Nhung chợt lên tiếng:

	– Bún ốc kia chúng mày ơi.

	Tôi nhìn quanh:

	– Đâu, bún ốc đâu?

	Nhung chỉ tay vô trong chợ:

	– Đó, bay mùi thơm nức mũi, thèm rỏ dãi đó không thấy sao?

	Nó chợt dừng xe lại, giục Liên ngồi phía sau:

	– Đi Liên, tao với mày vô chợ đớp bún ốc đi.

	Tôi cũng dừng xe, ngạc nhiên nhìn con bé “bốc đồng”. Bất thần Châu hỏi:

	– Không đi thăm thầy Huy à?

	Vẫn là ý kiến của Nhung:

	– Thôi tao không đi nữa. Tao đi… ăn bún ốc. Mày với con Thụy đi cũng được rồi. Chúng mày “đại diện” cho lớp mình ở nhà thầy Huy, tao với con Liên “đại diện” cho lớp mình ở… hàng bún ốc chợ Vườn Chuối vậy.

	Dù bực mình trước sự thay đổi bất thần của nó, tôi cũng phải phì cười trước câu trả lời… khỉ của con bạn nổi tiếng “tếu” nhất lớp. Tôi quay nhìn Châu hỏi ý:

	– Sao Châu? Hai đứa mình đi nhé.

	Châu có vẻ ngần ngại, nó buồn buồn:

	– Thôi vậy, tụi nó không đi, mình đi làm chi.

	Nhung…dụ dỗ:

	– Ừ, hai đứa mày đi không coi cũng… kỳ lắm hén, thôi, vô đớp bún ốc đi.

	Thấy tôi có vẻ ngần ngại, Nhung hăng hái thuyết phục:

	– Bún ở đây tao bảo đảm hết: bún nóng mới ra lò nè, ớt cay nè, chanh tươi nè, rau sống ngon nè, mắm ruốc… ngọt nè… Còn nước với ốc thì khỏi nói, một trăm phần trăm.

	Chỉ mới nghe Nhung “diễn tả” về cái món “phụ tùng” mà tôi đã thấy nước miếng ứa ra cổ. Châu biết nó đã mất đồng minh, nói xuôi xị:

	– Thì gởi xe rồi vô ăn. Đứng đó nói hoài.

	Bọn học trò bốn đứa lật đật khóa xe rồi kéo nhau vào chợ. Hàng bún ốc bốc khói thật hấp dẫn. Tôi và các bạn ngồi ngay xuống những cái đôn nhỏ. Bà hàng bún nhìn chúng tôi, vồn vã:

	– Các cô xơi bún?

	Nhung nhanh nhẩu:

	– Bà cho bốn tô.

	Tôi dặn dò:

	– Một tô không có ớt nghe bà.

	Châu thêm:

	– Tôi cũng không ăn ớt, hai tô đừng bỏ ớt đi bà.

	Liên vọt miệng:

	– Cho “tui” nhiều nhiều giá nha “dì”.

	Tôi cười, nhìn con nhỏ “giá sống” trăm phần trăm. Bốn tô bún được đặt trước mặt, ngút khói, chưa ăn đã thấy ngon. Xong chầu “bún ốc”, bốn đứa lại bàn nhau “làm gì cho hết thì giờ?”

	Liên nói:

	– Ngàn năm một thuở, đừng bỏ phí thì giờ vô ích, sức mấy mà tuần sau “ổng” còn nghỉ nữa.

	– Nhưng đi đâu bây giờ? Tôi hỏi:

	Nhung đề nghị:

	– Ciné đi.

	Châu gật:

	– Ciné cũng được, nhưng mà phim gì cơ chứ?

	– À há…

	Châu buông thõng. Nhung chợt reo lên:

	– Tao nhớ rồi, Văn Hoa chiếu phim hay lắm.

	– Phim gì? Ai đóng?

	Việc đầu tiên của chúng tôi là hỏi tên phim và… tài tử đóng phim đó. Chúng tôi xem phim chả cần cốt chuyện miễn tài tử mình thích là được. Nhung nói:

	– Ils n’ont que vingt ans.

	Liên gật gù:

	– A, tao biết rồi. Sandra Dee chớ gì.

	Châu phụ họa:

	– Được, ai chứ Sandra Dee thì nhất. Tao vẫn khoái nó cười.

	Tự dưng, tôi “nổi máu anh hùng” nói một câu… triết lý cùn:

	– Phải chi mình học bài thuộc như… thuộc tài tử ciné thì đỡ quá.

	Châu bĩu dài môi:

	– Cho tao xin đi… bà phước.

	Cả bọn cùng cười. Tôi không buồn cãi cối với chúng nó, thản nhiên rồ máy xe, Châu la chói lói:

	– Ê mày, bỏ tao hả?

	– Ừ bỏ. Cho mày lội bộ từ đây về tới rạp Văn Hoa luôn.

	Châu vừa vén vạt áo dài ngồi lên xe vừa càu nhàu:

	– Làm tàng hoài, ỷ có cái xe.

	Nhung vọt xe lên, réo:

	– Dẹp, đừng gây nhau nữa. Sandra Dee đang chờ kia kìa.')

insert into NOIDUNGSACH values
		('MS007','MC001',N'Hãy Là Chính Mình',N'“Warren Buffet từng nói: “Không bao giờ có ai giống bạn.” Một ý tưởng rất thâm thúy. Một con người khôn ngoan.
		Không bao giờ có ai giống như tôi. Và không bao giờ có ai giống như bạn. Sẽ có người cố gắng bắt chước cách bạn suy tư, nói năng, hành động. Nhưng dù
		cố gắng hết sức họ cũng chỉ đứng hàng thứ hai mà thôi. Vì bạn là duy nhất. Một bản thể duy nhất tồn tại hôm nay. Giữa hàng tỷ người khác. Hãy dừng lại
		và nghĩ về điều này. Bạn chợt nhận ra mình đặc biệt. Không, rất đặc biệt mới đúng. Và không thể có ai tranh giành được.

		Thế thì hôm nay, bạn làm gì khi bước vào thế giới cần những con người thể hiện vượt trội trong cuộc sống từ trước đến giờ? Bạn đã bộc lộ hết mọi khả
		năng tiềm ẩn chưa? Bạn đã tiết lộ con người chân thật của mình chưa? Bạn có là chính mình? Hãy tự hỏi. Bởi vì không còn lúc nào thể hiện chính mình tốt 
		hơn lúc này. Và nếu không phải bây giờ, thì khi nào? Tôi nhớ đến lời của triết gia Herodotus: “Thà chấp nhận rủi ro phải gánh chịu một nửa những chuyện
		xấu mà ta từng dự đoán trước, còn hơn giữ mãi sự vô danh hèn nhát vì sợ những điều có thể xảy ra.” Một lời nói tuyệt đẹp.'),

		('MS007','MC002',N'Sức Mạnh Của Sự Đơn Giản',N'Tôi học hỏi nơi các con rất nhiều. Các con tôi không những là người hùng mà còn là người thầy giỏi. Chúng 
		giúp tôi biết sống với hiện tại, giúp tôi thấy cuộc đời là một cuộc phiêu lưu và dạy tôi cách mở lòng ra. Chúng còn cho tôi nhiều bài học về sức mạnh của
		sự đơn giản. Lúc này mọi điều tôi theo đuổi đều đơn giản – một thông điệp đơn giản về tư tưởng: mọi người đều là lãnh đạo dù họ làm gì hoặc ở chức vụ nào;
		một ý tưởng và công cụ đơn giản giúp người khác xây dựng sự nghiệp; một cuộc sống đơn giản hơn (vì thực ra, tôi đã là người sống rất đơn giản). Đối với tôi,
		đơn giản rất mạnh mẽ. Nhà đồng sáng lập Google Sergey Brin đã nhấn mạnh điều này khi nói rằng ở công ty ông “thành công đến từ sự đơn giản”.

		Điều đó khiến tôi nhớ đến cậu con trai Colby của mình. Chúng tôi đến thành phố New York cách đây vài tháng, cùng nhau chia sẻ một trải nghiệm mà cả hai đã lên kế
hoạch từ lâu: ăn mừng sinh nhật lần thứ 13 (để đánh dấu con tôi trở thành một thiếu niên, chỉ có một lần trong đời). Chúng tôi ăn tại nhà hàng Soho. Đi siêu thị mua
		đồ chơi. Ghé cửa hàng Lotteria ưa thích của con. Cùng xem bộ phim 3D mới nhất. Một ngày cuối tuần đầy những niềm vui quí giá và những kỷ niệm không thể nào quên. Giữa cha và con.

		Tối Chủ nhật trên đường trở về nhà, tôi hỏi: “Thế con thích nhất điều gì trong ngày cuối tuần vừa qua?”. Nó ngồi thinh lặng. Suy nghĩ trầm tư. Rồi nó mỉm cười
		nói: “Bố còn nhớ cái bánh hot dog mình ăn trên hè phố hôm qua không? Con thích nó nhất đấy.” Đúng là Sức mạnh của sự đơn giản. ')
go

insert into NOIDUNGSACH values
		('MS008','MC001',N'Tìm Kiếm Sự Xoa Dịu Chỉ Khiến Bạn Bị Tổn Thương',N'Nỗi buồn của tất cả mọi người thường bắt nguồn từ một người khác

		“Bạn mệt lả rồi đúng không? Để chúng tôi giúp bạn thư giãn”

		Có lần đang đứng đợi xe buýt trong một dịp đến thăm thành phố nọ, tôi bất chợt bị thu hút bởi những dòng chữ trên tấm biển quảng cáo. Hình như đó là quảng cáo 
		cho một thiết bị bán tại siêu thị ở địa phương.

		Trên tấm biển quảng cáo là một bức tranh phong cảnh vô cùng yên bình. Một thiếu nữ nằm dài thư giãn bên hàng ngàn bông hoa ngát hương với vẻ mặt vô cùng thoải mái
		. Khoảnh khắc nhìn bức tranh, tôi chợt nhận ra lâu nay mình chẳng thấy thanh thản gì cả, tôi nảy ra ý đinh đến cái chỗ kia để ai đó giúp tôi thả lỏng gân cốt, dù chỉ một lúc thôi cũng được.

		Hai người phụ nữ khoảng 30 tuổi đứng chờ xe buýt ngay cạnh tôi có vẻ cũng chú ý đến tham biển quảng cáo này.

		“Nghe hay phết nhỉ? Mình cũng muốn được thư giãn! “

		“Phải khoảng đấy? Ngày nào mình cũng bị stress, thật sự rất mệt mỏi “

		Cuộc nói chuyện nghe qua chẳng có điều gì bất thường, nhưng thực ra, nhũng lo lắng của họ dường như chẳng thể nào giải quyết được.trước mắt họ là sự tồn tại của một bẫy rập lớn.

		Ảnh hưởng của sự “doa xịu”đến mỗi người cũng gần giống như sự an ủi tạm thời.Hiểu được điều đó, ta sẽ thấy được hiểu quả thực sự của “xoa dịu” trong 
		việc giúp thay đổi tâm trạng con người. Phần lớn những người luôn tìm kiếm sự an ủi từ ai đó đều mong được giải thoát khỏi nỗi phiền muộn. Họ hy vọng 
		sự xoa dịu giống như một loại ma thuật giúp họ giải quyết tất cả mọi thứ.

		Tuy nhiên, không ai ngờ rằng, nếu muốn thay đổi tình trạng bế tắc của mình bằng cách đó thì họ đã sai lầm nghiêm trọng.

		Tôi làm việc ở hiroshima với tư cách một nhà tâm lí học. Hiện tại tôi đã thành lập công ty tư nhân phi lợi nhuận nhưng trước đây tôi từng làm việc cho 
		lực lượng phòng vệ mặt đất nhật bản.tôi là chuyên viên tâm lí hiện trường đầu tiên của lực lượng phòng vệ mặt đất,làm việc cho bộ Quốc Phòng

		Suốt 5 năm, tôi trị liệu tâm lí cho những binh sĩ chịu nhiều áp lực. Họ nhận thức được tình trạng nguy hiểm đe doạ tính mạng mỗi ngày.
Thực ra, trước khi học tâm lí và trở thành tư vấn viên,tôi từng là một người lính tự vệ vô cùng bình thường phục vụ cho quân đội 8 năm, sau khi tôi tốt 
		nghiệp cấp 3.hơn nữa,tôi bị số mệnh khắc nghiệt đùa giỡn, trải qua bạo lực gia đình mắc chứng trầm cảm, ly hôn và bị lừa. Đến khi nhận ra điều đó thì
		tâm hồn đã chịu không biết bao nhiêu tổn thương và tan vỡ, không cần như thuở ban đầu.

		Có lẽ do bản thân từng trực tiếp trải nghiệm những điều ấy cho nên trong khoảng thời gian làm việc tại quân đội, tôi khá gần gũi với những người lính. 
		Trong lực lượng phòng vệ toàn quốc, tôi vô cùng tự hào khi binh sĩ tín nhiệm luôn đạt top đầu và tỉ lệ thành công phục chữ lên đến 90%,trở thành một
		phòng tư vấn “phải xếp hàng mới có thể vào”với khoảng 2000 buổi trò chuyện/hội thảo.

		Ở vị trí này. Tôi từng chứng kiến nhiều người mang trong mình những nỗi niềm khác nhau.

		Có những người tự nhiên cảm thấy khó chịu mà không biết nguyên nhân tại sao,cũng có những người chìm trong đau khô vì cuộc sống không như mong muốn. 
		Tuy mức độ mỗi người khác nhau nhưng nỗi phiền muộn của họ lại gần như tương đồng.

		Mỗi người đều gặp rắc rối trong những mối quan hệ xã hội, hay có thể nói, mối quan hệ giữa bản thân và “một người khác”.Người này có thể là đồng nghiệp,
		cấp trên, người yêu hoặc bạn đời, thậm chí là cha mẹ hay người đã khuất.”Hầu hết những vấn đề mọi người bị bận tâm đều bắt nguồn từ một người khác.

		Những người tìm đến tôi đều bị quấn bởi nỗi lo âu và muốn nhah chóng được giải thoát những đau đớn khổ sở ấy. Tuy nhiên càng muốn được xoa dịu thì họ lại
		càng bị xoáy sâu hơn vào nỗi đau khổ.

		Hai người phụ nữ đứng chờ xe buýt cùng tôi khi đoá có lẽ cũng vậy dựa dẫm vào sự xoa dịu. Để thoát khỏi nỗi đau khổ tâm,họ chọn cách đi tắm onsen(suối nước nóng) 
		hoặc tìm kiếm dịch vụ massage.

		Nếu muốn thay đổi tâm trạng và thư giãn thì điều này hoàn toàn tốt,nhưng nếu muốn giải quyết rắc rối hay thoát khói đau khổ thì đây không phải phải phương án tối ưu.
		Tôi không khuyến khích bạn lựa chọn phương án này.

		Càng muốn được an ủi thì bạn càng không đạt được điều đó.'),
('MS008','MC002',N'Khi Mệt Mỏi Đừng Có Cố Gắng Tìm Kiếm Sự Doa Xịu',N'Mỗi khi gặp một chuyện gì đó, chúng ta thường nỗ lực hết sức để tự mình giải quyết vấn đề.

		Có những người vượt qua được và tiếp tục đứng lên, nhưng cũng có những người vẫn dậm chân tại chỗ, vấn đề không những không được giải quyết mà còn trở nên trầm trọng hơn.

		Điều gì tạo nên sự khác biệt?

		Hầu hết những người không giải quyết được vấn đề của mình đều mơ tưởng rằng sẽ có ai làm gì đó giúp họ, kiểu như tiền sẽ rơi từ trên trời xuống hay chỉ cần uống thuốc theo
		đơn thì sẽ khỏi bệnh.

		Tương tự như vậy, những khi buồn bã hay đau khổ, ta thường cầu cứu ai đó giúp mình loại bỏ nỗi đau bằng một thứ ma thuật mang tên “xoa dịu”.Nhưng đáng tiếc, chẳng có gì gọi
		là ma thuật ở đây cả.

		Sự xoa dịu chỉ có thể giúp bạn thư thả được trong phút chốc nhưng không có nghĩa sẽ giúp bạn giải quyết vấn đề.

		Trên thực tế, không có bệnh nhân nào đến khám ở chỗ tôi có thể hồi phục hay xóa bỏ lo âu chỉ dựa vào sự xoa dịu.

		Khi rơi vào cơn khủng hoảng, chúng ta thường có xu hướng coi sự “xoa dịu” như chiếc phao cứu sinh.Sự xoa dịu lúc đó dẫu sao cũng chỉ mang tính chất nhất thời nên nỗi buồn
		sẽ không bao giờ tan biến.

		Khi ấy, khoảng cách giữa sự thanh thản chốc lát và nỗi khổ sở thực sự khiến ta phải mệt mỏi.

		“lạ thật! Không thể thế này được. Rõ ràng mình được xoa dịu rồi mà.. “và ta mong muốn được xoa dịu nhiều hơn nữa trong nỗi lo âu ngày càng lớn, rồi phó mặc mình, để bản thân
		tiếp tục tổn thương.

		Sau khổ và mong muốn được xoa dịu là một vòng tuần hoàn vô tận.

		Nhiều mối bận tâm ập đến bủa vây=>cố gắng tìm kiếm sự xoa dịu để giải tỏa stress =>khủng hoảng vì không giải quyết được hiện thực=>tiếp tục mong muốn được xoa dịu nhiều hơn.

		Mỗi khi bế tắc, ai mà chẳng muốn được an ủi, thế nhưng chẳng điều đó không hề khi vấn đề biến mất mà lại đẩy chúng ta lấn sâu vào một mê trận. Thực ra,cái ý định giải
		toát lo âu bằng cách “xoa dịu”lại là “bẫy rập” liên nhất mà chúng ta sa phải.

		Hãy nhớ rằng, càng cảm thấy khổ sở, bạn càng không được tìm đến sự xoa dịu. Nếu vấn đề của bản thân vẫn chẳng thể giải quyết được, bạn sẽ chìm sâu vào đau khổ, và thậm
chí con đường đầy trông gai phía trước sẽ còn gập gắng trắc trở hơn nhiều so với hiện tại.')
go

insert into NOIDUNGSACH values
		('MS009','MC001',N'Trại giam khu giam nữ',N'Ngày… tháng… năm…

		Có một loài chim luôn hót vào đầu hạ, lúc sẩm tối, hoặc là sau cơn mưa hoặc vào các đêm trăng sáng. Tiếng hót lại nghe thê thiết, não nề. Nó khiến người ta nghĩ về nỗi
		mất mát, nhớ về những điều đã qua, thời gian và cả sự vô thường.

		Lần đầu tiên bước chân vào nơi lạnh lẽo âm u ấy, tôi đã không ngừng tự hỏi, lí do gì mình lại ở đây? Tôi đã gây ra tội lỗi gì để đến bước đường cùng này? Tôi phải chịu 
		đựng sự giày vò, dằn vặt mỗi ngày, mỗi giờ, mỗi phút. Chúng ám ảnh tôi trong những giấc ngủ chẳng tròn. Nước mắt không ngừng chảy mỗi đêm bằng cả ngàn ngày cộng lại,
		tôi chờ đợi đến lúc bản án tử được đề ra.

		Tôi sợ.

		Nhưng phải thanh thản đón nhận.

		Vì tôi, thật sự là kẻ có tội.

		Nhật kí tù nhân 3969.

		*****

		Tháng 8 năm 2017.

		Buổi sớm đầu thu ở Trại giam nằm trên một con đường thuộc Sài Gòn, vang lên tiếng khua lịch kịch lạnh tanh từ ổ khóa gỉ sét, phá tan sự tĩnh lặng buồn bã ở nơi này. 
		Bác sĩ Đồng Văn cầm theo chồng hồ sơ bệnh lí, khẽ lách mình đi qua khoảng trống vừa đủ giữa cửa hàng rào mục với bức tường ố vàng cao sững.

		Văn chậm rãi tiến vào bên trong khoảng sân vắng vẻ sau khi cảm ơn bảo vệ. Dưới làn gió thu mát dịu, Văn vận áo khoác xanh sậm với những đường sọc xám. Hai mép áo ép 
		sát vào mỗi khi anh co người lại, giấu bên trong bộ blouse trắng, thứ màu riêng biệt và xa lạ giữa không gian lạnh lẽo âm u ở Trại giam.

		Vài phút băng qua bãi đất trống, tốc độ đôi chân nhanh hơn, Văn sắp đến nhà của quản giáo khu giam nữ. Dừng lại ở bậc tam cấp xi măng cao nhất, Văn gõ cửa bằng âm 
		thanh thật đều, đôi vai hơi chùng xuống cho vài giây chờ đợi.

		Chẳng quá lâu cửa mở nhanh, xuất hiện một phụ nữ trung niên khoác bộ áo cảnh phục màu xanh lá cây quen thuộc thể hiện cho công lí và thật thi pháp luật. Đó là chịNgà, cán bộ quản giáo khu giam nữ tại đây. Nhác thấy gương mặt Văn đứng trước cửa lúc trời còn tờ mờ sáng, chị ngạc nhiên hỏi:

		– Bác sĩ Văn đến tìm chị sớm vậy?

		Văn chậm rãi đưa chồng hồ sơ bệnh lí cho chị Ngà, mỉm cười bảo đây là kết quả kiểm tra của các phạm nhân nữ hồi tuần trước. Chị Ngà khẽ lướt mắt qua từng hồ sơ xem 
		còn sót ai không, rồi tự dưng chậc lưỡi:

		– Bác sĩ Văn nhọc công quá, để lát chị qua khu bệnh xá lấy cũng được mà.

		– Em sắp đến gặp Phó giám thị Dũng, tiện thể qua đây đưa chị luôn.

		– Bác sĩ gặp Phó giám thị có chuyện gì sao?

		– Cũng chỉ là báo cáo tình hình tâm lí của một phạm nhân nam bên khu II. Lát, em phải đi gặp một người, sợ là không kịp đến lúc Phó giám thị đi họp về.

		Sự tò mò trong đôi mắt quản giáo Ngà hiện lên rõ rệt. Văn chẳng che giấu gì, nói rằng chốc nữa anh sẽ đi gặp Hoàng Oanh. Tức thì đôi mắt chị Ngà sáng lên do mừng rỡ 
		trước cuộc tái ngộ sắp diễn ra giữa những người xưa:

		– Thế à? Mèn ơi, cũng lâu lắm rồi đấy! Bé Oanh vẫn khỏe chứ?

		– Bé Oanh sống với chú Thạch rất tốt, năm nay nó sẽ vào trường trung học.

		– Tốt rồi, thế này thì Vân Du cũng yên lòng…

		Chưa kịp nói hết câu thì sự ngập ngừng tràn ra đầu lưỡi khiến âm thanh mắc lại cuống họng, quản giáo Ngà phát hiện mình vừa nhắc lại cái tên không nên nhắc trước 
		mặt Văn. Chị càng tự trách hơn khi thấy nỗi buồn xuất hiện trong mắt anh. Đối diện, như hiểu sự im lặng đột ngột đó, Văn cất tiếng:

		– Em cũng nghĩ vậy. Hẳn, Vân Du rất vui khi con gái có cuộc sống tốt.

		Dẫu khỏa lấp bằng nụ cười nhẹ nhàng thanh thản nhưng nỗi buồn sâu thẳm vẫn ngự trị trong đáy mắt tối đen do đứng ngược chiều sáng, Văn không thể che giấu được quản
		giáo Ngà. Người phụ nữ này chợt hiểu, có lẽ sau ngần ấy năm chàng bác sĩ trẻ thuở xưa chưa một lần thôi đau. Lẽ nào, có những yêu thương trải qua nhiều năm cách biệt 
		chẳng hề vơi bớt mà ngày càng sâu đậm?

		Chị Ngà liền hỏi sang lí do Hoàng Oanh đến gặp Văn là gì. Chàng bác sĩ ba mươi ba tuổi trả lời với giọng đều đều:

		– Em cần đưa lại cho bé Oanh cuốn nhật kí của Vân Du, năm nay con bé đã mười hai tuổi rồi. Đó là lời hứa của em…Tiếng chuông điện thoại thình lình vang lên. Giấu tiếng thở dài đặc trưng, quản giáo Ngà đến bên bàn, nhấc máy nghe. Văn nhìn chị quay lại với nét mặt biểu hiện ý 
		nghĩa rằng chị sẽ phải rời khỏi đây bây giờ.

		– Có rắc rối ở dãy nhà khu giam nữ, chị phải qua đó xem sao. Bác sĩ gặp bé Oanh thì gửi lời hỏi thăm của chị nhé.

		Dặn dò xong câu cuối cùng, quản giáo Ngà liền đi như chạy về phía dãy nhà khu giam nữ. Còn lại một mình, Văn bước chậm rãi xuống từng bậc tam cấp, thả bộ ra khoảng 
		sân vắng vẻ. Nắng sớm lấp liếm sắp chảy tràn lên chân, Văn đảo mắt nhìn quanh. Không phải tò mò quan sát, mà chỉ để nhớ.

		Một thời gian dài, Văn ít khi đến đây. Mỗi lần có việc, quản giáo Ngà sẽ đến bệnh xá tìm anh. Văn nhìn cảnh vật hiện tại, cứ ngỡ khung cảnh sáu năm trước đang tái hiện.

		Vẫn lớp cỏ úa bên dưới bị giẫm đạp không mọc lên nổi. Vẫn bóng cây cao uể oải cho một cái vươn mình trong nắng sớm. Vẫn là những luống rau, bụi hoa do các phạm nhân 
		nữ thay nhau trồng vào giờ lao động. Cuối cùng, vẫn bốn bức tường vàng ố bao bọc xung quanh, phía trên là dãy hàng rào kẽm sắc bén từng làm chùn chân nhiều kẻ liều
		lĩnh muốn bỏ trốn.

		Chỉ một bức tường, bên kia và bên này, ấy vậy tạo nên hai thế giới khác xa nhau. Tự do và tù đày. Chỉ một giây phút lầm lỡ thôi, ai đó sẽ mãi mãi bỏ lại sau lưng
		bầu trời rộng lớn xanh ngát, bỏ lại tháng ngày sống trọn vẹn kiếp người để bước chân vào đây.

		Trại giam, nơi không biết đã đón nhận bao nhiêu kẻ tội lỗi, dường như mất hẳn bốn mùa xuân hạ thu đông. Tồn tại duy nhất ở đây là ngày sang đêm, chờ đợi quyện với 
		nước mắt. Đằng sau chấn song sắt đen, mỗi người mang trong mình câu chuyện riêng, bi kịch riêng mà chẳng ai giống ai.

		Gió nổi. Những đám mây bị đánh tan ra trôi lãng đãng vô tư lự, trả lại cho bầu trời vùng trong xanh yên ả, sắc màu đó mang đến sự an nhiên lạ lùng.

		Một cánh bướm màu xanh dương thẫm hiển hiện dưới đáy mắt Văn, bay chấp chới qua hàng rào kẽm trên bức tường. Con vật mê chơi bay lạc vào chốn tù đày u ám. Sự phát
		hiện thú vị làm chàng trai trẻ tiếp tục nhìn theo đôi cánh rực rỡ kia rung rinh trong gió. Con bướm đậu lên khóm hoa nghiêng ngả bên dưới, vui đùa là bản năng của loài phù du.Gió thổi mạnh hơn, mang theo những chiếc lá trên cành cây trụi lơ. Gió vô tình hất nhẹ con bướm xanh vướng vào cành hoa. Nó mắc kẹt, giãy cánh mãi.

		Cái nhìn của Văn đong đầy phân vân giữa việc giúp đỡ hay để con bướm tự thoát ra. Nhưng Văn sẽ không thể biết được kết quả của hai điều đó khi một bàn tay mềm mại 
		luồn qua khóm hoa, nhẹ nhàng tháo đôi cánh xinh đẹp ra khỏi sự mắc kẹt. Con vật mang ơn, bay là là xung quanh người đó. Một cô bé mười sáu tuổi.

		Cho em tự do, không phải tù đày

		Quên đi năm tháng hao gầy thương anh

		Em ở bên này một bức tường ranh

		Đêm ngày trông ngóng mong manh chờ người…

		Cô bé cất tiếng hát, giọng trong trẻo bay vút. Tưởng chừng như thứ thanh âm réo rắt không bị xiềng xích đó vượt qua bức tường chết chóc lạnh lẽo, qua hàng rào kẽm giam
		cầm đến với bầu trời cao. Không gì bó buộc được cô.

		Văn đứng chết lặng, sững sờ đến mức không rõ hình ảnh đang thấy là thật hay mơ, là người hay chỉ là ảo ảnh nhóm lên từ nỗi thương nhớ tràn trề. Cô bé đứng gần bụi hoa mặc
		chiếc váy trắng dài qua đầu gối, gương mặt nghiêng nhẹ bừng sáng, mái tóc ngắn mềm mại phủ ót cùng một đôi vai mỏng manh.

		– Vân Du…

		Sau tiếng gọi thân thương phát ra từ bờ môi Văn, cô bé với chiếc váy trắng tung xòe đã quay qua nhìn với đôi mắt phẳng lặng tựa bờ hồ thu. Cô hơi nghiêng đầu, nở nụ cưởi
		êm đềm với anh. Điều ấy khiến Văn càng thêm choáng ngợp trong niềm hân hoan đường đột này. Với sự xúc động mãnh liệt, Văn đã không biết đôi chân mình đang tiến lại gần.

		Vân Du vẫn đứng yên, sự im lặng toát lên người cô tạo thành một lớp vỏ bọc đơn độc giống hệt năm xưa. Tại thời khắc này, Văn khao khát muốn ôm trọn lấy Du, cảm nhận hơi
		ấm da thịt lan tỏa vào nhau, điều mà khi Du còn sống anh không bao giờ được làm. Thế nhưng đôi tay xụi lơ, Văn mất hết sức lực để nhấc lên, để ôm cô…

		*****

		Cuối tháng 3 năm 2011.

		Đêm mưa sáu năm trước thật khác với đêm mưa của những năm sau đó. Nó dữ dội, ướt át, vần vũ. Tiếng mưa nghe hệt âm thanh gào thét ai oán từ đất trời. Số phận có lẽ biết 
		được một bi kịch thảm thiết sắp xảy đến nên để cơn mưa này là một điềm báo trước. Chẳng ai nhận ra giọng hét kinh hoàng của người phụ nữ len lỏi qua màn mưa buốt giá, tê
		tái. Thứ âm thanh ám ảnh phát ra từ bệnh viện đa khoa.Ngay cửa phòng bệnh, dáng cô hộ lí ngồi sững bất động, hoàn toàn lả đi như mất hết sự sống, riêng đôi mắt vẫn mở trừng trừng phản chiếu nỗi bàng hoàng và hai bàn tay bấu
		chặt vào thành cửa đến nỗi tươm máu. Những người xung quanh từ y tá, bệnh nhân cho đến người thăm bệnh, ngạc nhiên khi thấy cô hộ lí chẳng hiểu vì sao lại thét lên thất 
		thanh rồi ngồi bệt dưới đất như bị đột qụy. Trước đó, ai nấy đều giật mình vì nghe tiếng la của những người trong phòng bệnh, họ chạy ra ngoài đầy sợ hãi.

		Tất cả liền chạy đến. Và khi đưa mắt nhìn vào phòng, lập tức họ đồng loạt mang những hành động không khác cô hộ lí ban nãy. Sững sờ. Hãi hùng. Thậm chí, có người yếu bóng
		vía đến nỗi ngất lịm.

		Ở giữa căn phòng trắng lạnh lẽo, được mô tả bằng mùi thuốc sát trùng nồng nặc và mấy dụng cụ y tế kim loại khô khốc, bóng dáng cô gái trẻ đứng nghiêng người toát lên hơi
		nồng tanh tưởi của máu. Dung dịch đậm đà mùi sắt đó vấy bẩn quần áo cô mặc, lên gương mặt từ mang tai xuống cằm, lên cả những sợi tóc ngắn lòa xòa hơi rối. Nơi nhuốm máu 
		nhiều nhất, là bàn tay phải cô đang cầm kéo. Mũi kéo sắc lẹm, chết chóc. Dưới đất có hai thân thể nằm bất động.

		Mọi cử động trên người cô gái trẻ đều đứng yên, giống hệt bị hóa đá. Duy nhất một thứ nơi cô đang chuyển động, nhen nhúm sự nhận thức hiếm hoi. Đôi mắt. Với cái nhìn sâu,
		tăm tối như đáy hồ nhưng vẫn le lói chút hoang mang. Như kiểu, khung cảnh man rợ bày ra trước mặt lúc này không phải do cô cố ý gây nên. Dù vài phút trước thôi, chính cô 
		đã đâm mạnh chiếc kéo vào hai cơ thể ấm nóng, kết thúc mạng sống của họ.

		Buông kéo. Cô xoay người thật chậm, chẳng khác gì khúc cây gãy bị đau, ánh mắt vô hồn sâu hun hút vô tình lướt qua mấy chục gương mặt xa lạ xuất hiện ngay cửa phòng, giờ
		đây chỉ còn những nét nhăn nhúm hãi hùng.

		Nhưng không có ý dọa họ, cũng không có ý thể hiện bản thân là kẻ cuồng sát, cô đang tìm kiếm một bóng hình nhỏ bé mà nãy giờ mình đã để vụt mất khỏi tầm mắt. Cái nhìn đau
		đáu mong mỏi khiến người ta nghĩ, thứ mà kẻ sát nhân đó đang tìm hẳn vô cùng quan trọng, biết đâu đấy là phần tốt đẹp duy nhất còn sót lại trong trái tim tội lỗi.Vài phút sau, bờ môi trắng bệch nứt nẻ chợt mấp máy, nụ cười nhẹ nhõm lướt qua khi cô thấy trong góc tường đứa con gái nhỏ đang ngồi co người, trông giống lưng tôm. Mái 
		đầu của nó tựa lên hai đầu gối, đôi mắt tròn nhìn khung cảnh máu đổ người chết mà không chút sợ hãi, chỉ ngơ ngác. Bóng đổ từ chiếc tủ cao ngay bên cạnh chảy tràn trên 
		thân hình và nhấn chìm nó vào màn tối.

		Mau chóng, con bé nghe tiếng ai gọi tên mình, bằng hơi thở mệt mỏi:

		– Hoàng Oanh, lại đây với mẹ.

		Bé Oanh ngước nhìn cô gái đứng trước mặt với cơ thể mềm ngặt nhưng vẫn cố đứng vững, như chống chọi lại bất hạnh do số phận đè xuống. Từ nãy đến giờ, nó thắc mắc không 
		hiểu cô gái vừa giận dữ vừa đâm kéo vào hai người kia để rồi sau đó bị nhuốm máu trên quần áo ấy, có phải mẹ Du? Vì khi nghe tiếng la đau đớn của bà ngoại kế thì nó bỗng
		sợ. Tuổi còn nhỏ không cho phép nó nhận thức được ý nghĩa hành động mà mẹ gây ra cho bà. Nhưng giờ nghe tiếng gọi quen thuộc đó, bé Oanh chắc mẩm mẹ Du đây rồi.

		– Mẹ Du ơi!

		Vân Du đón con gái vào lòng, không bận tâm nó sẽ khó chịu với mùi tanh đeo bám trên người mình. Du vùi mặt vào mái tóc thơm ngát của con vì muốn lưu giữ mùi thơm êm
		đềm này thật lâu bởi hiểu rõ, lát nữa thôi cô phải rời xa Oanh. Một thời gian dài, hay cũng có thể suốt đời Du sẽ mãi mãi không gặp lại con được nữa.

		Không lâu sau, công an được gọi đến. Họ giải tán đám đông hiếu kỳ rồi ập vào căn phòng nơi diễn ra cuộc sát hại. Dáng vẻ ai nấy đều thận trọng dè dặt vì họ nghe người
		gọi điện nói với giọng đứt quãng về “một tên sát nhân cuồng loạn”. Khung cảnh khiến người ta muốn choáng ngất vì mọi thứ đều nhuốm máu, bên dưới hai xác người nằm im 
		lìm, cơ thể ngập trong dung dịch màu đỏ.

		Nhưng khi nhóm công an lia mắt sang tên giết người thì gương mặt họ được vẽ lên bởi sự ngạc nhiên, là một cô gái ngoài đôi mươi đang ôm đứa trẻ tầm sáu tuổi. Cả hai có 
		vẻ quyến luyến không rời. Trông cứ như thể đây là cuộc đoàn viên mỹ mãn, và nó thật đối lập với không gian chết chóc ghê rợn.

		Nhóm công an đứng tần ngần vài giây, thình lình nghe tiếng giục gấp gáp của ai đó trong đám đông đang hồi hộp quan sát sự việc:– Con nhỏ tóc ngắn giết người đó! Gì mà ác dữ vậy trời! Công an mau bắt nó nhanh đi, kẻo nó điên lên giết luôn đứa trẻ, tội nghiệp!

		Hai người công an bước đến kéo xốc Du đứng dậy, để hai tay cô ra phía sau. Hai người khác đẩy bé Oanh lùi ra. Không hề kháng cự, Du đứng yên như khúc gỗ, mặc công an tra 
		còng số tám lạnh ngắt vào tay mình. Khi người ta cảm nhận rõ rằng mọi thứ kể từ giờ đã kết thúc thì hành động kháng cự chẳng còn ý nghĩa nữa.

		Du đờ đẫn, mất luôn cảm giác đau dù bị những bàn tay thô cứng bấu siết vào người mình. Về phía bé Oanh, nó ngó cảnh mẹ mình tự dưng bị ba bốn người đàn ông xa lạ dẫn đi, 
		vẻ mặt ngẩn ngơ. Ngay chính nó cũng đang bị kìm giữ. Bé Oanh bỗng liên tưởng đến mấy câu chuyện cổ tích mẹ Du hay kể, về việc kẻ xấu xa thường bắt những đứa trẻ nhỏ đi mất.
		Tức thì, nó gào khóc giãy giụa:

		– Bỏ ra! Bỏ ra đồ xấu xa! Mẹ Du, cứu con! Mẹ Du ơi!

		Nghe bé Oanh vừa khóc vừa gọi, bấy giờ Du mới sực tỉnh, hồn trở lại xác kéo theo sự tỉnh táo quay về. Lập tức đưa mắt nhìn con gái, Du thảng thốt:

		– Oanh! Oanh à! Chờ mẹ nhé!

		Nhận thấy nữ tội phạm có ý muốn chạy đến chỗ đứa bé gái, hai người công an bên cạnh giữ chặt Du hơn, đồng thời kéo cô ra khỏi phòng.

		Đám đông đứng xem dần tản ra tránh đường cho công an áp tải tội phạm ra ngoài xe. Vài âm thanh bàn tán trỗi dậy khe khẽ như tiếng vỗ cánh vo ve của lũ ruồi muỗi bay khắp 
		không gian bốc mùi tử khí nơi đây. Họ đang tự hỏi nguyên do gì khiến cô gái trẻ măng này xuống tay giết chết hai mạng người.

		*****

		Tiếng chuông điện thoại đổ vang nghe đứt quãng, giữa căn phòng tĩnh mịch chìm trong bóng tối, cùng lúc bên ngoài sấm rền vang não nề. Chuông kêu dai dẳng khô khốc làm bật
		tung một giấc ngủ mơ màng chỉ vừa thiếp đi khoảng vài phút. Mí mắt cục cựa kèm theo âm thanh trở mình uể oải, Đồng Văn xoay người nằm ngay ngắn trên giường, nén chặt giấc
		ngủ mà khó khăn lắm mới đến với mình, trong từng nhịp thở đều đều.

		Văn mở mắt chớp chớp vài cái cho quen với bóng tối, lòng tự nhủ chẳng rõ chủ nhân cuộc gọi là quản giáo Ngà bên khu giam nữ hay quản giáo Thái bên khu giam nam. Văn nhanhchóng ngồi dậy, đôi mắt vừa mới mở đang cố tìm kiếm trong bóng tối đen kịt chiếc điện thoại bàn với từng hồi chuông réo rắt. Đưa tay chụp lấy, anh bắt máy. Giọng của quản 
		giáo Thái đầy thúc giục bên kia, bảo rằng có một phạm nhân tinh thần không ổn định nên Văn hãy qua khu phòng giam.

		Văn đứng dậy, vớ lấy áo khoác dày màu xám, bước ra khỏi phòng bệnh xá. Bên ngoài mưa giăng lối mịt mùng khiến đêm tối càng thêm tối đen như mực. Không tiếng động nào tồn
		tại giữa chuỗi âm thanh va đập của hàng ngàn giọt nước lạnh giá buông xuống đất. Mưa trong Trại giam thường lạnh lẽo, rét mướt hơn bên ngoài rất nhiều. Màn mưa dữ dội cũng
		không làm Văn bận tâm khi cầm dù chạy băng qua khoảng sân rộng ngập nước lênh láng.

		Dọc theo dãy hàng rào ngăn cách, bóng đèn neon vàng vọt trên cao hắt ra thứ ánh sáng leo lét, trở thành ngọn hải đăng giữa đêm mưa bão. Mặc mưa đổ xuống chiếc dù dữ dội 
		như cú đánh của người lực lưỡng, Văn tiếp tục lội nước mưa ngập gần đến nửa ống quần, bằng những bước hối hả đến phân trại số II.

		Cùng thời điểm đó, người công an ấn mạnh Vân Du ngồi xuống ghế. Họ đang tiến hành làm giấy cho phạm nhân nhập trại. Lúc họ ngồi trên xe áp tải, mưa rất lớn và bây giờ vẫn
		chưa thuyên giảm, tiếng mưa rơi lộp bộp trên mái tôn của căn phòng không quá rộng nhưng yên ắng đến ngột ngạt này.'),

		('MS009','MC002',N'Tra hỏi tình huống giết người',N'Trước mặt Du là một công an đang chuẩn bị giấy bút. Còn sau lưng là nhóm công an bắt giữ khi nãy. Có vẻ Du chưa nhận thức được rõ ràng tình hình hiện tại của bản thân.

		Cái nhìn trống rỗng, gương mặt Du xanh xao, những giọt nước mưa chưa kịp khô chảy từng dòng xuống cằm. Mưa làm mái tóc ngắn bết sát vào cổ nhiễu nước tong tong xuống đôi vai xụi lơ. Chiếc áo Du mặc màu máu đỏ nhạt đi, loang ra một vùng vì ướt. Hai bàn tay với làn da trắng nhợt nhạt đặt trên đầu gối chụm lại, cổ tay để yên trong còng số tám kim loại, bị ướt nó càng thêm lạnh.

		Trong đầu Du lởn vởn những điều sắp bị tra hỏi và cô biết chắc mình sẽ không thể trả lời câu nào cả. Du thấy tâm trạng hiện tại rất tệ, do chưa tĩnh tâm được. Âm thanh bấm viết kêu khẽ, người công an Trại giam thở mạnh yêu cầu nữ phạm nhân khai báo lí lịch.Hàng mi ướt nước nặng trĩu chớp nhẹ, giọng Du rời rạc chỉ nói bằng hơi thở nên rất nhỏ. Người công an ngừng viết, khẽ lia ánh mắt về phía Du trong khi cô đang cố để từ ngữ thoát ra từ cổ họng mình qua đôi môi nứt nẻ.

		– Hai mươi ba tuổi? Thanh niên bây giờ chẳng xem pháp luật ra gì.

		Du lặng im, cố dằn xuống một tiếng thở nặng nề trong lồng ngực. Nó được tựu hình từ cảm xúc khó chịu dồn nén. Có chút thay đổi. Nét mặt Du tự dưng lạnh tanh, băng giá. Không rõ là do câu nói vừa rồi của người công an kia hay do nước mưa đã lấy hết sức sống trên từng mảng da mặt.

		– Hãy nói số điện thoại nhà để chúng tôi gọi cho gia đình chị.

		– Tôi chỉ sống với con gái sáu tuổi…

		– Chị có con gái sáu tuổi?

		Người công an tiếp tục nhìn Du, nhíu mày. Du hiểu trong đôi mắt đó đang ẩn chứa dòng suy nghĩ gì, về việc cô sinh con khi chưa thành niên. Tiếp, anh ta hỏi:

		– Vậy chị không còn người thân nào sao?

		– Tôi còn một người cha… Nhưng tôi chẳng còn quan hệ gì với ông ta.

		– Số điện thoại của cha chị là gì?

		– Đừng gọi ông ta đến đây, tôi rời khỏi nhà sáu năm rồi.

		Người công an nhắm mắt chán chường trước sự cứng đầu của phạm nhân trẻ tuổi. Anh chống khuỷu tay lên bàn, đầu hơi nghiêng qua phải, cao giọng:

		– Này, thế vì sao lại giết người? Tôi cần nói chuyện với cha chị, hiểu chứ? Việc chị gây ra là trọng tội, gia đình chị sẽ được báo.

		Bản thân Du chẳng thể nói rõ nguyên nhân khiến mình đi đến bước đường cùng này khi ra tay giết hai mạng người. Mọi ngôn từ hay những hành động liên quan đến chuyện bào chữa cho mình, tất cả đều khó khăn đối với Du.

		Mặc nhiên, Du muốn bỏ chạy. Không hẳn là trốn chạy trước hành vi phạm pháp mình vừa gây ra mà chính xác, cô muốn chạy trốn khỏi thứ cảm xúc đang đè nặng. Nó làm Du đau kinh khủng. Du gọi đó là sự ân hận, cắn rứt. Tiếp theo lại nghĩ đến Hoàng Oanh, đứa con gái đáng thương không thể sống nếu thiếu cô.Để mặc ánh nhìn sốt ruột cùng mấy câu hỏi cứ tua đi tua lại từ người công an đối diện, Du lướt đôi mắt qua các vật dụng trên bàn. Du tìm kiếm một vật dù bản thân chưa hình dung kỹ thứ ấy, mãi đến khi đôi mắt mau chóng chớp lấy đường nét của con dao rọc giấy. Để rồi tích tắc, hành động đến nhanh hơn suy nghĩ, Du đột ngột bật dậy đẩy ngã chiếc ghế phía sau xuống đất làm vang lên âm thanh “rầm”.

		Trước khi để nhóm công an kịp ngạc nhiên thì Du đã lập tức lao đến chụp lấy con dao rọc giấy. Việc tiếp theo, Du xoay qua đối diện với họ, quơ quơ con dao nhỏ sắc lẹm với kiểu đe dọa lẫn thách thức. Nhóm công an lùi ra sau vài bước, hai tay giơ lên đồng thời nói chậm rãi như trấn an nữ tội phạm đang kích động.

		Thật chất, nỗi lo lắng từ nhóm công an hoàn toàn dư thừa bởi Du không có mục đích tấn công họ. Người mà cô nhắm đến, đáng ngạc nhiên thay, chính là mình! Tất cả chợt hiểu ra ý định tự sát khi thấy cô gái quay ngược mũi dao lại. Nhưng khi Du định dùng hết sức đâm dao vào cơ thể đang sống của mình thì thình lình một người công an chẳng rõ đã vòng ra sau lưng cô tự lúc nào, lao đến kịp thời chụp lấy tay đối phương.

		Hai người công an khác cũng chạy lại kìm giữ Du. Họ đè cô nằm ngửa xuống mặt bàn, giật lấy con dao. Lúc ngã mạnh xuống cho đến lúc cảm nhận cú nhói ở sau lưng, đối với Du diễn ra chưa đầy một phút. Thở hổn hển, đầu ngoẹo sang bên, cô nhìn ra bên ngoài khung cửa sổ bị phủ ướt bởi màn mưa trắng xóa.

		Đêm nay kỳ lạ quá đỗi, mưa cứ dai dẳng hệt như đã lâu lắm rồi Sài Gòn mới có mưa. Trùng hợp thay, cái ngày tàn khốc làm thay đổi cuộc đời Du cũng ướt át giống vậy. Như lẽ hiển nhiên, mỗi lần có mưa, đời cô lại rẽ bước ngoặt mới. Nhưng nó không hề tốt đẹp, chỉ là sự giày vò của số phận…

		Kìm giữ được Du rồi, bấy giờ công an mới phát hiện lớp da dưới cánh tay phải cô bị đứt toạc một đường, máu chảy loang khắp mặt bàn. Ban nãy trong lúc giằng co, lưỡi dao bén nhọn kia đã kịp cắm vào da thịt lạnh lẽo ấy. Không còn cách nào khác, họ đành gọi bác sĩ đến băng bó vết thương cho Du.Vị bác sĩ trung niên của trại tên Hiên với cặp kính xệ xuống cánh mũi, cẩn thận rửa vết thương trên tay Du. Dù trời mưa và không khí lạnh bao trùm, ấy thế ông vẫn toát mồ hôi liên tục. Nguyên nhân cũng bởi ông bắt gặp đôi mắt tối đen của Du, giống đáy hồ sâu phủ đầy lục bình, chẳng một tia sáng nhỏ nhoi nào tồn tại.

		Một ánh mắt khiến người ta bất an.

		Công việc băng bó cũng xong xuôi. Vị bác sĩ quệt mồ hôi, quay qua nhóm công an nói về tình hình vết thương. Chỉ trong một khoảnh khắc từ kẽ hở rất nhỏ, khi ánh mắt những người mặc quân phục rời khỏi mình, Du nhanh như cắt rút lấy cây kéo trong cặp của bác sĩ. Không muốn thất bại giống khi nãy, lần này Du giữ kéo rồi đâm vào bụng mình.

		Kim loại xé rách da thịt để chui vào bên trong cơ thể, cảm giác đau kinh khủng. Đó là điều duy nhất Du nhận thấy khi ngã nhào xuống đất. Trước khi ngất lịm, những bóng dáng loáng thoáng lướt qua trước mặt nhưng Du vẫn nhìn về cửa sổ. Phản chiếu trong đôi mắt tăm tối hơn ao tù ấy, hình ảnh những giọt mưa rơi mãi. Rồi một đốm sáng vụt lóe lên qua cái nhìn khoắc khoải. Dẫu thế, tia sáng đã tắt rất nhanh, chẳng khác gì ngôi sao nhỏ giữa đêm tối mịt mùng bị màn mưa vùi lấp.

		*****

		Sáng hôm sau, Đồng Văn đến gặp Phó giám thị Dũng. Âm thanh xê dịch cửa kêu khẽ, Phó giám thị Dũng rời mắt khỏi đống giấy tờ, nhìn lên thấy chàng bác sĩ trẻ bước vào. Gương mặt nghiêm nghị biến mất thay vào đó là nụ cười nhẹ nhàng, anh rời bàn đi vòng lên trước đối diện với Văn:

		– Có một phạm nhân nữ tinh thần không ổn định. Tôi đã yêu cầu vài bác sĩ đến kiểm tra nhưng tình hình khá tệ. Hết cách, tôi đành phải nhờ anh.

		– Phạm nhân nữ ấy gặp vấn đề gì?

		Phó giám thị Dũng chậm rãi cầm lấy xấp giấy A4 bấm kim nằm ngay ngắn trên mặt bàn. Hẳn ai cũng đoán được, đây là tài liệu thông tin về nữ phạm nhân trẻ tuổi kia. Lướt sơ qua dòng chữ đánh máy chi chít, anh đọc cho Văn nghe:

		– Phạm nhân tên Vân Du, hai mươi ba tuổi, khoảng tuần trước đã sát hại hai người trong bệnh viện. Du không bằng cấp, nghề nghiệp không ổn định, công việc chủ yếu là làm bán thời gian trong một siêu thị. Du sống với con gái tên Hoàng Oanh sáu tuổi. Có một người cha và mẹ kế…Phó giám thị Dũng ngưng lại, tiếp tục hướng mắt vào Văn. Đó không phải cái nhìn lưỡng lự chỉ là việc sắp tiết lộ về một điều bất ngờ. Lông mày đang chau lại chợt dãn ra nhẹ nhàng, nét mặt bình thường hơn khi anh thở dài:

		– Người phụ nữ bị giết là mẹ kế của phạm nhân.

		Văn khó hiểu trước hành động giết người tàn nhẫn của cô gái tên Vân Du. Mẹ kế, tuy không phải ruột thịt nhưng cũng là vợ của cha, chưa kể lại sống chung một nhà, tại sao cô ta có thể thẳng tay giết bà ấy? Phía sau chuyện này liệu có uẩn khúc hay chỉ đơn thuần Du là kẻ điên loạn? Văn hỏi tiếp về nạn nhân thứ hai. Phó giám thị Dũng hạ giọng:

		– Đó là một bác sĩ trẻ tên Dương, ở khoa nhi của bệnh viện đó. Anh ấy chết ngay tại chỗ với một vết đâm chí mạng ngay tim.

		– Vân Du, cái tên rất hay, nghĩa là rong chơi cùng mây. – Văn nhìn những đám mây vô hại trôi lãng đãng qua bầu trời, nói câu chẳng ăn nhập gì với nội dung cuộc đối thoại nãy giờ – Vậy vấn đề phạm nhân đó gặp là gì?

		– Ngay trong đêm vừa vào Trại giam, Du đã tự đâm mình. Trước, là con dao rọc giấy, sau đó đến kéo của bác sĩ. Suốt mấy ngày nằm điều trị ở khu bệnh xá, phạm nhân này tinh thần khá bất ổn và thường gọi tên con gái Oanh.

		Phó giám thị Dũng quay trở lại bàn đặt xấp giấy xuống. Âm thanh kéo ghế kêu kít, anh lồng hai bàn tay vào nhau, nói tiếp vấn đề kia:

		– Tóm lại, chúng ta cần củng cố tinh thần cho phạm nhân Vân Du.

		Văn xem câu nói nghiêm túc phát ra từ vị Phó giám thị này là một yêu cầu ngầm dành cho mình: “Hi vọng bác sĩ sẽ giúp đỡ phạm nhân”.

		Đây vốn dĩ là công việc của Văn nhưng có một điều thầm kín nào đó đã biến thành sự cản trở. Thật sự Văn mang ác cảm với những kẻ sát nhân. Dù thế, Văn hiểu bản thân cần gạt nó qua một bên. Anh là bác sĩ tâm lí, nhiệm vụ hàng đầu là điều trị cho bệnh nhân chứ không phải thi hành pháp luật. Với một lương y, phán xét con người là điều tối kị.

		– Tôi biết phải làm gì. Liệu, cái án mà phạm nhân đó gánh lấy là tử hình?

		– Có thể, căn cứ theo điều 93 Bộ Luật hình sự.

		Văn nở nụ cười kỳ lạ, có lẽ mang hàm ý về một điều hoang đường nào đấy:

		– Đã là tử tù, nếu muốn tự tử thì vì sao chúng ta phải ngăn cản? Bởi dù gì đi nữa trước sau gì họ cũng chết.– Họ sẽ chết nhưng không được bằng cách tự tử. Chính luật pháp mới có quyền kết thúc cuộc đời họ. Phạm tội thì sẽ bị trừng phạt. Trước khi lãnh án của tòa, họ buộc phải sống. Họ cần biết, mình là kẻ có tội.

		– Đó là sự nhân từ trong pháp luật?

		– Đó là sự công bằng!

		Phó giám thị Dũng nhấn mạnh năm từ cuối như muốn kết thúc cuộc tranh luận mặc cả về sinh mạng tù nhân. Gương mặt đăm chiêu, ánh nhìn đanh sắc, anh đang yêu cầu chàng bác sĩ trẻ ngừng việc chỉ trích tử tù. Anh kéo Văn về đúng với nhiệm vụ của mình, công việc của một bác sĩ điều trị tâm lí.

		Hiển nhiên Văn nhận ra điều đó qua dáng vẻ nghiêm nghị từ vị Phó giám thị trung niên. Không nói gì thêm, Văn khẽ cúi đầu rồi bước ra khỏi phòng. Có lẽ một bác sĩ như anh sẽ khó mà hiểu được những lời đó.

		Khi cánh cửa khép lại, Phó giám thị Dũng mới thở ra thật mạnh. Anh có phần ngạc nhiên trước phản ứng kỳ lạ của Văn, trong khi bình thường Văn vẫn là một bác sĩ thân thiện. Sự ác cảm vừa rồi là do Văn bất mãn trước tội ác của Du hay còn ẩn chứa bí mật gì? Khẽ khàng, Phó giám thị Dũng nhìn ra bên ngoài cửa sổ phòng, nơi những cành cây khẳng khiu phủ màu xanh lá. Lòng tự nhủ, một mùa hạ nữa lại đến ở Trại giam.

		***

		Vân Du không nghĩ mạng mình lại lớn đến vậy. Rõ ràng khi đó chiếc kéo đã đâm vào bụng, Du cảm nhận cái đau ghê gớm như thể đang cận kề cái chết, ấy vậy sau cùng vẫn được cứu sống. Du hiểu, ngay cả quyền được chết mà mình cũng không thể có. Tiếp theo là cô phải gặp một bác sĩ tâm lí để điều trị.

		Đồng Văn mở cửa phòng bệnh xá bước vào, thấy người con gái ngồi ngay bàn khám như bừng tỉnh rồi chậm rãi ngước mặt lên. Ấn tượng đầu tiên của Văn đối với Du là một nỗi u uất bao phủ khắp người cô, da dẻ nhợt nhạt như mất hết sức sống. Mọi đường nét trên gương mặt đều cứng đơ chẳng khác gì tượng đá. Đặc biệt là đôi mắt. Tối đen, sâu hút không có lấy điểm sáng nào. Dẫu Du đang nhìn mình nhưng Văn cảm giác đôi mắt đó cứ treo lơ lửng ở một nơi nào rất xa xôi.Văn đến bên bàn, kéo chiếc ghế ở phía đối diện ra và ngồi xuống. Du im lặng, không có biểu hiện của việc bắt đầu cuộc đối thoại. Nhẹ nhàng đặt hồ sơ bệnh lí cùng cuốn sổ nhật kí lên bàn, Văn làm nhưng vẫn kín đáo quan sát đối phương. Anh nhận ra Du thật sự không nhận thức về sự hiện diện của mình.

		– Tôi tên Đồng Văn, bác sĩ tâm lí của Trại giam. Kể từ giờ, tôi sẽ điều trị cho phạm nhân Vân Du. Mong cô hợp tác với tôi để việc điều trị được thuận lợi.

		Văn giới thiệu ngắn gọn, cốt chỉ để kéo sự chú ý của Du trở về thực tại. Nhưng có vẻ nó chẳng đạt được kết quả gì bởi Du tiếp tục im lặng đồng thời hướng đôi mắt tối tăm vào một điểm chơi vơi trên vai anh chàng bác sĩ.

		Cuộc đối thoại chỉ mới bắt đầu mà lại có chiều hướng sắp đi vào ngõ cụt. Văn nhận ra Du đang mang nỗi u uất rất nặng nề. Chậm rãi kéo cuốn nhật kí ra giữa bàn, Văn đành nói tiếp những điều cần nói:

		– Một tuần chúng ta sẽ gặp nhau vào ngày thứ ba, nếu bệnh tình cô trở nên nặng hơn thì sẽ hai ngày, thậm chí là ba ngày. Để dễ dàng cho việc trị liệu, tôi muốn cô viết nhật kí. Không cần quá nhiều, đơn giản là viết ra những cảm xúc và suy nghĩ trong lòng vào mỗi ngày. Tôi sẽ theo dõi tâm lí của cô…

		– Không cần đâu bác sĩ.

		Cuối cùng Du cũng đã chịu lên tiếng. Hành động cắt ngang đột ngột diễn ra nhanh chóng, ngắn gọn. Văn lại nhìn Du, ngạc nhiên như muốn hỏi câu nói vừa rồi là có ý gì.

		– Trước sau gì tôi cũng lãnh án tử, làm thế chỉ vô ích.

		Ánh mắt Du vẫn tối lắm, nhưng không hiểu sao lại kiên quyết đến thế. Điều đó khiến Văn lấy làm lạ. Một khoảng lặng kéo đến lấp đầy cái không gian ngột ngạt chật chội ở nơi này. Những ngón tay gõ đều trên cuốn nhật kí, Văn tiếp lời:

		– Dù muốn chết thì cô cũng phải đứng trước tòa để lãnh án. Mà phiên tòa sẽ không mở khi phạm nhân đang bất ổn, vậy nên hãy chấp nhận điều trị đi.

		Du nghĩ, có lẽ đây là lần đầu tiên một bác sĩ lại khuyên nhủ phạm nhân bằng các lời lẽ thẳng thắn đến vậy. Không giáo điều hay sáo rỗng. Hẳn thế mà Du bấy giờ mới nhìn trực diện vào Văn, khi mà mấy phút qua cô đã lờ đi sự tồn tại của anh. Chàng bác sĩ trẻ mang gương mặt tĩnh lặng, điềm nhiên cùng với đôi mắt sâu thẳm mà vô cảm. Văn không né tránh Du, tự dưng đề cập đến vấn đề khác:

		– Cô có con gái sáu tuổi tên Hoàng Oanh?Du không đáp. Văn cũng chẳng cần câu trả lời vì sẽ hỏi câu thứ hai:

		– Vậy cha đứa bé là ai? Hiện đang ở đâu? Anh ta có biết cô bị bắt?

		Một sắc thái kỳ lạ lướt qua gương mặt tĩnh lặng đó. Văn dường như phát hiện có tia sáng sắc lẹm vụt lên trong đáy mắt Du. Hệt những điều Văn vừa hỏi đã vô tình chạm đến góc khuất sâu kín của người con gái bí ẩn này.

		Và rồi dĩ nhiên, Văn không nhận được đáp án nào cả ngoài tiếng thở khô khốc phát ra từ phía đối diện. Vì phản ứng khác thường ấy nên bất giác, trong Văn xuất hiện sự tò mò. Giờ thì anh đã hiểu vì sao bản thân lại thấy Du thật u uất, là bởi cô mang những bí mật.

		– Nếu cô điều trị cho tinh thần ổn định thì chí ít sẽ được gặp lại con gái.

		Văn đẩy cuốn nhật kí đến trước mặt Du một cách chậm rãi nhưng kiên quyết. Và cuộc gặp gỡ chóng vánh giữa họ ngày hôm đó kết thúc vẫn là trong sự im lặng từ Du.

		*****

		Vân Du mặc áo tù nhân sọc đen trắng mang con số 3969, chậm rãi theo gót quản giáo Ngà đi đến buồng giam số 5 khu II. Du sẽ phải ở đây một thời gian cho việc điều trị tâm lí ổn định và chờ phiên tòa xét xử được mở. Dãy hành lang dài vắng lặng nửa tối nửa sáng do ánh đèn neon vàng vọt hắt ra. Trời bên ngoài đã về đêm. Du không biết điều gì đang chờ đợi mình ở phía trước trong khoảng thời gian đợi chờ đằng đẵng sắp tới. Cô chỉ biết để mặc cho số phận dẫn lối, chẳng buồn kháng cự.

		Quản giáo Ngà mở khóa buồng giam, nhẹ nhàng quay qua nhìn nữ phạm nhân trẻ với một cái gật đầu khẽ như yêu cầu cô hãy bước vào. Đôi môi bợt bạt của Du mở hé, nói lời cảm ơn cán bộ. Du vừa bước vào, cánh cửa sắt của buồng giam số 5 lạnh lùng đóng lại.

		Du đưa mắt quan sát căn phòng khá rộng và thoáng với những ô cửa sổ nhỏ. Phòng xây hai bục cao lát gạch men sát tường, ở giữa là lối đi. Phía trên thêm hai tầng lửng. Những phạm nhân nữ trải chiếu nằm gần nhau và lúc này họ đang lần lượt ngồi dậy, mấy chục con mắt mở thao láo hướng về phía Du, phạm nhân mới vào buồng. Tia nhìn soi mói, hiếu kỳ, thản nhiên hay hăm dọa đều có.')
go
insert into NOIDUNGSACH values
		('MS010','MC001',N'Bức thư',N'Của đại úy Arthur Hastings

		Sĩ quan Hoàng gia AnhTrong truyện này, tôi không chỉ kể lại những sự việc và nơi chốn tôi có liên quan và có mặt, do đó một số chương truyện được viết theo ngôi thứ ba.

		Tôi xin cam đoan với độc giả rằng tôi có thể đảm bảo tính xác thực của các sự kiện trong các chương này. Nếu tôi có hơi lãng mạn trong việc miêu tả suy nghĩ và tình cảm của nhiều người khác nhau thì đó là vì tôi nghĩ tôi đã kể về họ một cách chính xác nhất. Ngoài ra, tôi cũng muốn nói thêm rằng những chương đó đều được ông bạn Hercule Poirot của tôi “duyệt” qua rồi.

		Tóm lại, tôi muốn nói là nếu tôi có miêu tả dài dòng các mối quan hệ riêng tư không quan trọng lắm nhưng xuất hiện trong loạt vụ án kỳ lạ này thì đó là vì yếu tố con người và cá nhân không thể bỏ qua được. Có lần Hercule Poirot đã bảo tôi các vụ án hay làm nảy sinh ra những mối tình lắm.

		Còn về việc phá vụ án A.B.C. bí ẩn này, tôi chỉ có thể nói rằng theo ý tôi Poirot đã chứng tỏ tài năng thật sự của ông trong việc xử lý một vấn đề hoàn toàn khác với những vụ ông đã phá trước đó.

		Tháng 6 năm 1935 tôi về thăm nhà sau chừng sáu tháng trời ở trang trại của mình bên Nam Mỹ. Thời gian đó thật là khó khăn. Cũng như mọi người, chúng tôi bị ảnh hưởng bởi suy thoái toàn cầu. Có nhiều việc ở Anh mà tôi cảm thấy phải đích thân xử lý thì mới ổn thỏa. Vợ tôi ở lại bên ấy quản lý trang trại.

		Đương nhiên, một trong những việc đầu tiên tôi làm khi về tới Anh là thăm ông bạn già Hercule Poirot của tôi.

		Tôi thấy Poirot sống trong một căn hộ cho thuê loại mới nhất ở Luân Đôn. Tôi chê (mà Poirot cũng đồng ý) rằng ông chọn sống trong tòa nhà này hoàn toàn là vì dáng vẻ vuông vức cũng như tầm cỡ của nó.

		“Đúng thế ông bạn à, những đường nét đối xứng nhìn dễ chịu, ông không thấy vậy sao?”

		Tôi nói tòa nhà quá nhiều góc vuông và lấy một chuyện đùa cũ để trêu ông rằng trong ngôi nhà siêu hiện đại này chắc người ta làm cho gà đẻ ra trứng vuông.

		Poirot phá lên cười sảng khoái.

		“Á, ông vẫn còn nhớ chuyện đó? Than ơi – khoa học chưa thể làm cho gà mái tuân theo thị hiếu mới, chúng vẫn đẻ trứng với đủ kích cỡ và màu sắc khác nhau thôi!” Tôi trìu mến ngắm nhìn ông bạn già. Poirot vẫn còn mạnh khỏe lắm và dường như chẳng già thêm chút nào kể từ lần gặp trước.
“Trông ông vẫn còn tinh anh lắm, ông Poirot ạ”, tôi nói. “Ông chẳng già thêm chút nào. Thiệt tình thì không thể tin được, nhưng có vẻ như ông ít tóc bạc hơn lần trước tôi gặp ông thì phải”.

		Poirot nhìn tôi mỉm cười.

		“Sao lại không tin cơ chứ? Đúng vậy mà”.

		“Ý ông là tóc ông chuyển từ bạc sang đen chớ không phải ngược lại sao?”

		“Đúng thế”.

		“Nhưng mà phản khoa học quá!”

		“Không hề”.

		“Nhưng vậy thì rất kỳ. Có vẻ trái tự nhiên”.

		“Hastings à, đầu óc ông lúc nào cũng suy nghĩ tốt đẹp và không bao giờ hoài nghi. Thời gian chẳng làm thay đổi cái tính đó của ông! Ông vừa thu nạp dữ kiện vừa đưa ra kết luận cùng lúc mà không hề hay biết mình đang làm như thế!”

		Tôi nhìn ông trân trối vẻ khó hiểu.

		Không nói thêm lời nào, ông bạn tôi đi vào phòng ngủ rồi trở ra với một cái chai trên tay và đưa cho tôi.

		Tôi cầm lấy mà vẫn chưa hiểu gì.

		Trên chai ghi:

		Revivit. – Mang lại màu sắc tự nhiên cho tóc của bạn. Revivit không phải là thuốc nhuộm. Có năm màu: màu tro, màu hạt dẻ, màu hung, màu nâu và màu đen.

		Tôi la lên: “Poirot, té ra là ông nhuộm tóc!”

		“À, cuối cùng ông cũng đã hiểu!”

		“Thế đó là lý do vì sao tóc ông lại đen hơn hồi tôi về gặp ông lần trước”.

		“Đúng vậy”.

		Vừa hết kinh ngạc, tôi nói: “Trời ạ, chắc lần tới tôi về không chừng lại thấy ông đeo ria giả – hay là ông cũng đang đeo ria giả đấy?”

		Poirot cau mày. Bộ ria luôn là điểm nhạy cảm của ông. Ông tự hào về chúng một cách cực kỳ thái quá. Câu nói của tôi khiến ông cáu.

		“Làm gì có, mon ami [1]. Tôi thề với ông cái ngày ấy vẫn còn xa lắm. Ria giả ư! Quel horreur [2]!”

		Ông kéo mạnh ria mép của mình để chứng minh với tôi. “À ừ, nó vẫn còn rậm rạp lắm”, tôi khen.

		“N’est ce pas? [3] Khắp Luân Đôn này chưa thấy bộ ria nào có thể so sánh với bộ ria của tôi đâu đấy”.

		Sự nghiệp của ông cũng thế mà, tôi thầm nghĩ. Nhưng tôi không dám nói ra, sợ lại làm ông bạn Poirot phật lòng.

		Thay vào đó tôi hỏi xem thỉnh thoảng ông có còn hành nghề không.

		“Tôi biết ông nghỉ hưu nhiều năm rồi…”
“C’est vrai. [4] Để trồng bí ngòi! Và rồi đột nhiên có một vụ án mạng xảy ra thế là đi tong cái vụ trồng bí ngòi. Và kể từ đó – tôi biết ông sẽ nói – tôi giống như kép chính đóng vở diễn cuối cùng! Cái vở diễn cuối cùng đó, cứ lặp đi lặp lại không biết bao nhiêu lần rồi!”

		Tôi cười xòa.

		“Đúng như vậy đấy ông bạn ạ. Mỗi lần tôi nói: lần này là kết thúc rồi; thì không, lại một vụ khác xảy ra! Và phải thừa nhận tôi muốn nghỉ hưu cũng không được. Nếu mấy cái tế bào chất xám nhỏ bé không được luyện tập, nó sẽ hoen gỉ mất”.

		Tôi đáp: “Hiểu rồi. Thế nên ông chỉ luyện tập chúng ở mức vừa phải thôi chứ gì”.

		“Chính xác. Tôi chọn lựa rất kỹ. Bởi giờ đây Hercule Poirot chỉ tham gia những vụ án hóc búa thôi”.

		“Có nhiều vụ như thế không?”

		“Pas mal. [5] Cách đây không lâu tôi thoát chết trong gang tấc”.

		Chẳng phải thế sao? Đúng thế.

		Không nhiều lắm.

		“Vì thất bại à?”

		Poirot có vẻ sửng sốt. “Không, không phải. Nhưng tôi, Hercule Poirot, suýt mất mạng”.

		Tôi rên lên một tiếng.

		“Một tên giết người táo bạo!”

		Poirot trả lời: “Táo bạo thì ít mà bất cẩn thì nhiều. Chính xác là rất bất cẩn. Nhưng thôi, đừng nói chuyện này nữa. Hastings biết không, xét trên nhiều phương diện tôi xem ông như bùa hộ mệnh của mình”.

		Tôi hỏi lại: “Thật ư? Như thế nào kia?”

		Poirot không trả lời thẳng, ông bảo:

		“Ngay khi biết ông đến tôi tự nhủ: sẽ có chuyện cho mà xem. Như thuở trước, hai đứa mình đi săn cùng nhau, chỉ hai đứa mình thôi. Nhưng nếu chỉ thế thôi thì hẳn không phải là chuyện thường. Phải có điều gì đó” – Ông hào hứng vẫy tay – “Điều gì đó tao nhã – thanh lịch – tinh tế…” Ông bỏ lửng từ cuối cùng không thể diễn tả nổi ấy.

		“Mèn ơi, Poirot. Người ta sẽ tưởng ông đang gọi món ăn ở nhà hàng Ritz mất”, tối nói.

		“Sao người ta không thể chọn vụ án nhỉ? Đúng thật”. Ông thở dài. “Nhưng nếu được, tôi tin vào sự may mắn, vào số phận. Số phận của ông là sát cánh bên tôi và ngăn tôi mắc những lỗi lầm không thể tha thứ”.

		“Những lỗi không thể tha thứ như lỗi gì?”

		“Bỏ qua những chi tiết quá rõ ràng”.

		Tôi ngẫm nghĩ nhưng vẫn chưa hiểu lắm.

		Sau đó tôi cười nói: “Vậy siêu tội phạm này đã xuất hiện chưa?”

		“Pas encore. [6] Ít ra là tôi nghĩ thế…”Poirot ngừng nói. Ông nhăn trán vẻ khó hiểu. Tay ông bất giác xếp lại mấy vật mà tôi vô tình đẩy sai chỗ.

		“Tôi cũng không chắc lắm”, ông chậm rãi trả lời.

		Có cái gì kỳ lạ trong giọng nói của Poirot đến nỗi tôi phải nhìn ông ngạc nhiên.

		Poirot vẫn nhăn trán nghĩ ngợi.

		Đột nhiên ông gật đầu dứt khoát rồi bước tới bàn làm việc gần cửa sổ. Không cần phải nói, mọi thứ trên bàn đều được dán nhãn và xếp theo từng ngăn để ông có thể lấy những giấy tờ ông muốn bất kỳ lúc nào.

		Ông chậm rãi quay lại chỗ tôi và cầm theo một bức thư đã mở. Ông đọc thầm một lượt rồi đưa cho tôi.

		“Nói cho tôi biết ông sẽ làm gì với cái này, mon ami?” Poirot lên tiếng.

		Tôi nhận bức thư từ tay ông, lòng gợn chút tò mò.

		Thư được đánh máy trên loại giấy trắng khá dày.

		Ngài Hercule Poirot, ngài tự huyễn hoặc chính mình rằng ngài có thể giải quyết những vụ án hóc búa mà bọn cảnh sát Anh đần độn tội nghiệp không làm được chăng? Hãy đợi xem ngài thông minh đến mức nào, ngài Poirot Thông Minh. Có thể ngài sẽ thấy vụ này khó nhằn đấy. Lo mà canh chừng Andover vào ngày 21 tháng này.

		Kính thư, A B C

		Tôi liếc qua bì thư. Địa chỉ trên đó cũng được đánh máy. Khi tôi để ý đến dấu bưu điện, Poirot nói: “Dấu bưu điện ghi WC1. Vậy, ông nghĩ sao?”

		Tôi nhún vai trả lại bức thư cho ông.

		“Tôi đoán là thằng điên điên khùng khùng nào đó gửi thôi”.

		“Ý ông sự việc chỉ đơn giản vậy thôi à?”

		“Chứ ông không thấy có vẻ điên sao?”

		“À, có chứ, ông bạn”.

		Giọng ông chùng xuống. Tôi tò mò nhìn ông.

		“Ông hơi nghiêm trọng hóa vấn đề rồi, Poirot à”.

		“Ông bạn ơi, một kẻ điên thì càng cần phải được xem xét nghiêm túc. Người điên rất nguy hiểm”.

		“Ừ, đương nhiên. Đúng thế… Tôi đã không nghĩ đến điều đó. Nhưng ý tôi là chuyện này có vẻ như trò đùa ngu ngốc. Có lẽ là một kẻ thích chè chén chân tám chân chín nào đó”.

		“Comment? [7] Chín à? Chín gì?”

		“Không có gì. Thành ngữ ấy mà. Ý tôi là thằng cha đó bị xỉn. Mà không, trời ạ, ý tôi là một gã say rượu ấy”.

		“Merci, [8] Hastings. Tôi biết từ “xỉn” rồi. Như ông nói đấy, chắc không có vấn đề gì nghiêm trọng thật…”

		Ngạc nhiên trước giọng điệu chưa thỏa mãn của Poirot, tôi gặng hỏi: “Chứ ông nghĩ là có à?”

		Poirot lắc đầu vẻ hoài nghi nhưng không nói gì thêm.
Tôi lại chất vấn: “Thế ông đã làm gì với lá thư đó?”

		“Còn làm gì nữa chứ? Tôi đưa cho Japp. Ông ấy cũng nghĩ như ông – một trò chơi khăm ngu ngốc – Japp bảo thế. Ở Scotland Yard, ngày nào họ cũng nhận được những thứ tương tự. Tôi cũng từng thế…”

		“Nhưng ông xem bức thư này là chuyện nghiêm túc?”

		Poirot chậm rãi trả lời.

		“Có điều gì đó ở bức thư này mà tôi không thích, Hastings ạ…”

		Dù không muốn nhưng giọng điệu của ông càng thúc giục tôi.

		“Vậy ư? Điều gì?”

		Poirot lắc đầu, nhặt lá thư lên rồi cất lại vào hộc bàn.

		Tôi hỏi: “Nếu ông coi là chuyện nghiêm túc, sao ông không làm gì cả?”

		“Tôi lúc nào cũng là người ưa hành động! Nhưng tôi có thể làm gì cơ chứ? Cảnh sát quận đã xem bức thư và họ cũng không coi là chuyện nghiêm túc. Không có dấu vân tay trên đó. Không có một manh mối nào để đoán ra kẻ viết thư”.

		“Vậy thực ra chỉ là bản năng của ông mách bảo thôi sao?”

		“Không phải bản năng, Hastings à. Bản năng là một từ dở. Mà là kiến thức và kinh nghiệm của tôi chỉ ra rằng có gì đó bất ổn ở lá thư này…”

		Poirot hoa tay múa chân khi không diễn đạt được bằng lời, rồi lại lắc đầu.

		“Có thể là tôi chuyện bé xé ra to. Dù sao cũng không làm gì được ngoài chờ đợi”.

		“Ừ, ngày 21 là thứ Sáu đấy. Biết đâu có một vụ cướp lớn xảy ra gần Andover…”

		“À, nếu được thế thì dễ chịu biết nhường nào…!”

		“Dễ chịu ư?” Tôi trợn mắt. Dùng từ đó trong hoàn cảnh này thì lạ quá.

		“Một vụ cướp có thể ly kỳ chứ sao mà dễ chịu được!” Tôi phản đối.

		Poirot lắc đầu quầy quậy.

		“Hiểu lầm rồi, bạn tôi ơi. Ông không hiểu ý tôi. Nếu là một vụ cướp thì đỡ quá vì nó loại bỏ được nỗi ám ảnh khác trong tôi”.

		“Ám ảnh về cái gì kia?”

		“Giết người”, Hercule Poirot đáp.'),

		('MS010','MC002',N'Không phải lời kể của Đại úy Hastings',N'Ông Alexander Bonaparte Cust đứng dậy và nhìn chằm chằm xung quanh căn phòng ngủ tồi tàn. Ngồi gò bó hồi lâu khiến lưng ông cứng đờ và khi ông đứng dậy vươn mình hết cỡ hóa ra ông khá cao. Cái dáng khòm khòm và cái kiểu nhìn như bị cận thị làm người khác hiểu nhầm.
Ông bước về phía chiếc áo khoác đã cũ sờn treo đằng sau cánh cửa, lấy trong túi áo ra một gói thuốc lá rẻ tiền và vài que diêm, ông đốt một điếu rồi quay lại chiếc bàn ông ngồi nãy giờ. Ông cầm quyển thông tin đường sắt lên đọc rồi xem lại danh sách tên được đánh máy. Ông lấy bút đánh dấu một trong những cái tên đầu tiên trong danh sách đó.

		Hôm ấy là thứ năm, ngày 20 tháng 6.')
go

insert into GIAODICH_MUASACH values 
	('KH0001', 'MS009', 90000, '2022-2-5'),
	('KH0002', 'MS010', 100000, '2022-12-1'),
	('KH0003', 'MS009', 100000, '2023-2-5'),
	('KH0003', 'MS010', 110000, '2023-5-5'),
	('KH0007', 'MS009', 100000, '2023-3-2'),
	('KH0008', 'MS010', 110000, '2023-4-15')

