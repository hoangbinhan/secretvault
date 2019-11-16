# secretvault
Các công nghệ phần mềm mới

Để chạy được project ta cần cài đặt cocoapod và pod install project:
	Bước 1: mở Terminal và chạy lệnh "sudo gem install cocoapods"
	Bước 2: nháy phải vào thư mục của project và chọn vào "New Terminal Tab at Folder" và nhập lệnh "pod install" 


Cấu trúc file trong thư mục SecrecVault:
	Base: Nơi lưu trữ nhưng khai báo định dạng lại các UI component
	Constant: Nơi lưu trữ khai báo các chuỗi sẽ đặt như mặc định (hằng) trong project như Key, thông báo lỗi,...
	Controllers: Nơi lưu trữ các chức năng của project như Browser, Contact, FileImport,.. gồm file giao diện và code để thực hiện các chức năng...
	Extension: Nơi lưu trữ khai báo mở rộng của các class như chuỗi, font, UIview, UserDefault,...
	Helper: Nơi lưu trữ một số hàm có chức năng riêng biệt được sử dụng nhiều lần cho nhiều màn hình như download file, cắt chuỗi, tách đuôi file,...
	Models: Lưu trữ các khai báo model dùng để lưu trữ
	Ultis: Lưu trữ một số hàm liên quan đề google adsmod(quảng cáo)
	Views: Dùng để custom một số thông báo, alert, ....
	
