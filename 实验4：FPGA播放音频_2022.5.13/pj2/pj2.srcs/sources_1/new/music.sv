`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/10 12:09:17
// Design Name: 
// Module Name: music
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pwm_buzzer(
	input				clk		,		//ʱ������
	input				rst_n	,		//�������룬Ϊ1ʱ����
	output				led	,	//���������
	
	output	reg			buzzer			//����������
	);
		
	assign led=rst_n;
	//��������
	localparam			M0 	= 98800,
						M1	= 95600,
						M2	= 85150,
						M3	= 75850,
						M4	= 71600,
						M5  = 63750,
						M6	= 56800,
						M7	= 50600;
	
	//�źŶ���
	reg		[16:0]		cnt0		;	//����ÿ��������Ӧ��ʱ������
	reg		[10:0]		cnt1		;	//����ÿ�������ظ�����
	reg		[5 :0]		cnt2		;	//������������������
	
	reg		[16:0]		pre_set		;	//Ԥװ��ֵ
	wire	[16:0]		pre_div		;	//ռ�ձ�
	
	reg		[10:0]		cishu		;	//���岻ͬ�����ظ���ͬ����
	wire	[10:0]		cishu_div	;	//�����ظ�����ռ�ձ�
	
	reg		[5 :0]		YINFU		;	//������������������
	
	//���������ĸ���
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			YINFU <= 36;
	end
	
	//����ÿ�����������ڣ�Ҳ���Ǳ�ʾ������һ������
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt0 <= 0;
		end
		else begin
			if(cnt0 == pre_set - 1)
				cnt0 <= 0;
			else
				cnt0 <= cnt0 + 1;
		end
	end
	
	//����ÿ�������ظ�������Ҳ���Ǳ�ʾһ����������������ʱ��
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt1 <= 0;
		end
		else begin
			if(cnt0 == pre_set - 1)begin
				if(cnt1 == cishu)
					cnt1 <= 0;
				else
					cnt1 <= cnt1 + 1;
			end
		end
	end
	
	//�����ж��ٸ�������Ҳ�����������й����ٸ�����
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt2 <= 0;
		end
		else begin
			if(cnt1 == cishu && cnt0 == pre_set - 1) begin
				if(cnt2 == YINFU - 1) begin
					cnt2 <= 0;
				end
				else
					cnt2 <= cnt2 + 1;
			end
		end
	end
	
	//���������ظ�����
	always @(*) begin
		case(pre_set)
			M0:cishu = 242;
			M1:cishu = 250;
			M2:cishu = 281;
			M3:cishu = 315;
			M4:cishu = 334;
			M5:cishu = 375;
			M6:cishu = 421;
			M7:cishu = 472;
		endcase
	end
	
	//���׶���
	always @(*) begin
			case(cnt2)	//��ֻ�ϻ�����
				0 : pre_set = M1;
				1 : pre_set = M2;
				2 : pre_set = M3;
				3 : pre_set = M1;
				4 : pre_set = M1;
				5 : pre_set = M2;
				6 : pre_set = M3;
				7 : pre_set = M1;
				8 : pre_set = M3;
				9 : pre_set = M4;
				10: pre_set = M5;
				11: pre_set = M0;
				
				12: pre_set = M3;
				13: pre_set = M4;
				14: pre_set = M5;
				15: pre_set = M0;
				
				16: pre_set = M5;
				17: pre_set = M6;
				18: pre_set = M5;
				19: pre_set = M4;
				20: pre_set = M3;
				21: pre_set = M1;
				22: pre_set = M5;
				23: pre_set = M6;
				24: pre_set = M5;
				25: pre_set = M4;
				26: pre_set = M3;
				27: pre_set = M1;
				28: pre_set = M2;
				29: pre_set = M5;
				30: pre_set = M1;
				31: pre_set = M0;
				
				32: pre_set = M2;
				33: pre_set = M5;
				34: pre_set = M1;
				35: pre_set = M0;
			endcase
	end
	
	assign pre_div = pre_set >> 1;	//����2
	assign cishu_div = cishu * 4 / 5;
	
	//��������������
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			buzzer <= 1'b1;
		end
		else if(pre_set != M0) begin
			if(cnt1 < cishu_div) begin
				if(cnt0 < pre_div) begin
						buzzer <= 1'b1;
				end
				else begin
						buzzer <= 1'b0;
				end
			end
			else begin
				buzzer <= 1'b1;
			end
		end
		else
			buzzer <= 1'b1;
	end
	
endmodule
	
	



