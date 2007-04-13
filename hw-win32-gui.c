#include <windows.h>
#include <winuser.h>
#include <stdio.h>
#include "types.h"
#include "hardware.h"

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);

#define IDT_TIMER1 101

static char sClassName[]  = "MyClass";
static HINSTANCE zhInstance = NULL;

const int dpi = 96;
const double inWidth = 9.0;
const double inHeight = 7.0;

/* foot-switch pushed status */
static u32 pushed[8];
/* LED 4-digit display text */
static char leds4_text[5] = "    ";
/* LED 1-digit display text */
static char leds1_text[2] = " ";

static u8 fsw_active = 0;

static HWND hwndMain;

/* main entry point */
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	WNDCLASSEX WndClass;
	MSG Msg;

	int i;

	zhInstance = hInstance;

	WndClass.cbSize        = sizeof(WNDCLASSEX);
	WndClass.style         = CS_DBLCLKS;
	WndClass.lpfnWndProc   = WndProc;
	WndClass.cbClsExtra    = 0;
	WndClass.cbWndExtra    = 0;
	WndClass.hInstance     = zhInstance;
	WndClass.hIcon         = LoadIcon(NULL, IDI_APPLICATION);
	WndClass.hIconSm       = LoadIcon(NULL, IDI_APPLICATION);
	WndClass.hCursor       = LoadCursor(NULL, IDC_ARROW);
	WndClass.hbrBackground = (HBRUSH)(COLOR_BACKGROUND);
	WndClass.lpszMenuName  = NULL;
	WndClass.lpszClassName = sClassName;

	if(!RegisterClassEx(&WndClass)) {
		MessageBox(0, "Error Registering Class!", "Error!", MB_ICONSTOP | MB_OK);
		return 0;
	}

	hwndMain = CreateWindowEx(
		0,
		sClassName,
		"MIDI controller test harness",
		WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		(int)(inWidth * dpi) + 9,
		(int)(inHeight * dpi) + 28,
		NULL,
		NULL,
		zhInstance,
		NULL
	);

	if(hwndMain == NULL) {
		MessageBox(0, "Error Creating Window!", "Error!", MB_ICONSTOP | MB_OK);
		return 0;
	}

	SetTimer(hwndMain,         // handle to main window
		IDT_TIMER1,            // timer identifier
		10,                    // 10-ms interval
		(TIMERPROC) NULL);     // no timer callback

	ShowWindow(hwndMain, nCmdShow);
	UpdateWindow(hwndMain);

	for (i = 0; i < 8; ++i) {
		pushed[i] = 0;
	}

	/* initialize the logic controller */
	controller_init();

	/* default Win32 message pump */
	while(GetMessage(&Msg, NULL, 0, 0)) {
		TranslateMessage(&Msg);
		DispatchMessage(&Msg);

		/* give control to the logic controller */
		controller_handle();
	}

	return Msg.wParam;
}

/* scaled drawing routines: */

BOOL dpi_MoveTo(HDC hdc, double X, double Y) {
	MoveToEx(hdc, (int)(X * dpi), (int)(Y * dpi), NULL);
}

BOOL dpi_LineTo(HDC hdc, double X, double Y) {
	LineTo(hdc, (int)(X * dpi), (int)(Y * dpi));
}

BOOL dpi_CenterEllipse(HDC hdc, double cX, double cY, double rW, double rH) {
	Ellipse(hdc,
		(int)((cX - rW) * dpi),
		(int)((cY - rH) * dpi),
		(int)((cX + rW) * dpi),
		(int)((cY + rH) * dpi)
	);
}

BOOL dpi_TextOut(HDC hdc, double nXStart, double nYStart, LPCTSTR lpString, int cbString) {
	TextOut(hdc, (int)(nXStart * dpi), (int)(nYStart * dpi), lpString, cbString);
}

/* paint the face plate window */
void paintFacePlate(HWND hwnd) {
	HDC			hDC;
	PAINTSTRUCT	Ps;
	char		num[2];

	HFONT	fontLED;
	HPEN	penThick, penThin;
	HBRUSH	brsWhite, brsRed, brsGreen;

	int		hCount = 0, vCount = 0;
	double	inH, inV;

	hDC = BeginPaint(hwnd, &Ps);

	fontLED = CreateFont(
		(int)(0.394 * dpi),
		(int)(0.236 * dpi),
		0,
		0,
		FW_SEMIBOLD, FALSE, FALSE, FALSE,
		ANSI_CHARSET, OUT_DEFAULT_PRECIS,
		CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
		DEFAULT_PITCH | FF_ROMAN,
		"Courier New"
	);
	penThick = CreatePen(PS_SOLID, 2, RGB(0, 0, 0));
	penThin  = CreatePen(PS_SOLID, 1, RGB(0, 0, 0));
	brsWhite = CreateSolidBrush(RGB(255, 255, 255));
	brsRed = CreateSolidBrush(RGB(250, 25, 5));
	brsGreen = CreateSolidBrush(RGB(25, 250, 5));

	SetBkMode(hDC, TRANSPARENT);
	SetTextColor(hDC, RGB(32, 64, 127));

#if 0
	/* draw grid at 1/4" sections: */
	for (inH = 0; inH <= inWidth; inH += 0.25, hCount = (hCount + 1) % 4) {
		if (hCount == 0) {
			SelectObject(hDC, penThick);
		} else {
			SelectObject(hDC, penThin);
		}
		dpi_MoveTo(hDC, inH, 0);
		dpi_LineTo(hDC, inH, inHeight);

		vCount = 0;
		for (inV = 0; inV <= inHeight; inV += 0.25, vCount = (vCount + 1) % 4) {
			if (vCount == 0) {
				SelectObject(hDC, penThick);
			} else {
				SelectObject(hDC, penThin);
			}
			dpi_MoveTo(hDC, 0, inV);
			dpi_LineTo(hDC, inWidth, inV);
		}
	}
#endif

	SelectObject(hDC, penThin);
	SelectObject(hDC, brsWhite);

	/* draw 4x evenly spaced foot-switches for presets 1-4 */
	for (hCount = 0; hCount < 4; ++hCount) {
		SelectObject(hDC, penThick);
		dpi_CenterEllipse(hDC, 1.5 + (hCount * 2.0), 3.5, 0.34026, 0.34026);
		SelectObject(hDC, penThin);
		dpi_CenterEllipse(hDC, 1.5 + (hCount * 2.0), 3.5, 0.30, 0.30);
		if (pushed[hCount] != 0) {
			SelectObject(hDC, brsRed);
			dpi_CenterEllipse(hDC, 1.5 + (hCount * 2.0), 3.5, 0.25, 0.25);
			SelectObject(hDC, brsWhite);
		}
		sprintf(num, "%1d", hCount + 1);
		dpi_TextOut(hDC, 1.475 + (hCount * 2.0), 4.0, num, 1);
	}

	/* draw 4x evenly spaced foot-switches for PREV, NEXT, DEC, INC */
	for (hCount = 0; hCount < 4; ++hCount) {
		SelectObject(hDC, penThick);
		dpi_CenterEllipse(hDC, 1.5 + (hCount * 2.0), 5.5, 0.34026, 0.34026);
		SelectObject(hDC, penThin);
		dpi_CenterEllipse(hDC, 1.5 + (hCount * 2.0), 5.5, 0.30, 0.30);
		if (pushed[hCount + 4] != 0) {
			SelectObject(hDC, brsRed);
			dpi_CenterEllipse(hDC, 1.5 + (hCount * 2.0), 5.5, 0.25, 0.25);
			SelectObject(hDC, brsWhite);
		}
	}

	/* label the PREV, NEXT, DEC, INC foot-switches */
	dpi_TextOut(hDC, 1.325, 6.0, "PREV", 4);
	dpi_TextOut(hDC, 3.325, 6.0, "NEXT", 4);
	dpi_TextOut(hDC, 5.380, 6.0, "DEC", 3);
	dpi_TextOut(hDC, 7.410, 6.0, "INC", 3);

	/* draw 4x evenly spaced 8mm (203.2mil) LEDs above 1-4 preset switches */
	SelectObject(hDC, penThin);
	SelectObject(hDC, brsRed);
	for (hCount = 0; hCount < 4; ++hCount) {
		if (hCount != fsw_active) {
			dpi_CenterEllipse(hDC, 1.5 + (hCount * 2.0), 2.5, 0.2032, 0.2032);
		}
	}
	DeleteObject(brsRed);

	SelectObject(hDC, brsGreen);
	dpi_CenterEllipse(hDC, 1.5 + (fsw_active * 2.0), 2.5, 0.2032, 0.2032);
	DeleteObject(brsGreen);

	/* write the 4-digit and 1-digit LED displays */
	SetBkMode(hDC, OPAQUE);
	SetBkColor(hDC, RGB(40,10,10));
	SetTextColor(hDC, RGB(255,0,0));
	SelectObject(hDC, fontLED);
	dpi_TextOut(hDC, 1.02, 1.02, leds4_text, 4);
	dpi_TextOut(hDC, 4.02, 1.02, leds1_text, 1);
	DeleteObject(fontLED);

	DeleteObject(penThick);
	DeleteObject(penThin);

	EndPaint(hwnd, &Ps);
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT Message, WPARAM wParam, LPARAM lParam) {
	switch(Message) {
		case WM_CLOSE:
			DestroyWindow(hwnd);
			break;
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		case WM_PAINT:
			paintFacePlate(hwnd);
			break;
		case WM_KEYDOWN:
			/* only fire if the previous button state was UP (i.e. ignore autorepeat messages) */
			if ((lParam & (1<<30)) == 0) {
				switch (wParam) {
					case 'Q': case 'q': pushed[0] = 1; break;
					case 'W': case 'w': pushed[1] = 1; break;
					case 'E': case 'e': pushed[2] = 1; break;
					case 'R': case 'r': pushed[3] = 1; break;
					case 'A': case 'a': pushed[4] = 1; break;
					case 'S': case 's': pushed[5] = 1; break;
					case 'D': case 'd': pushed[6] = 1; break;
					case 'F': case 'f': pushed[7] = 1; break;
				}
				/* TODO: fix to only redraw affected button */
				InvalidateRect(hwnd, NULL, TRUE);
			}
			break;
		case WM_KEYUP:
			/* handle toggle button up */
			switch (wParam) {
				case 'Q': case 'q': pushed[0] = 0; break;
				case 'W': case 'w': pushed[1] = 0; break;
				case 'E': case 'e': pushed[2] = 0; break;
				case 'R': case 'r': pushed[3] = 0; break;
				case 'A': case 'a': pushed[4] = 0; break;
				case 'S': case 's': pushed[5] = 0; break;
				case 'D': case 'd': pushed[6] = 0; break;
				case 'F': case 'f': pushed[7] = 0; break;
			}
			/* TODO: fix to only redraw affected button */
			InvalidateRect(hwnd, NULL, TRUE);
			break;
		case WM_TIMER:
			switch (wParam) {
				case IDT_TIMER1: controller_10msec_timer(); break;
			}
			break;
		default:
			return DefWindowProc(hwnd, Message, wParam, lParam);
	}
	return 0;
}

/* --------------- LED read-out display functions: */

/* show 3 digits of decimal on the 4-digit display */
void leds_show_4digits(u8 value) {
	sprintf(leds4_text, "%4d", value);
	InvalidateRect(hwndMain, NULL, TRUE);
}

/* show 4 alphas on the 4-digit display */
void leds_show_4alphas(char text[LEDS_MAX_ALPHAS]) {
	strncpy(leds4_text, text, 4);
	InvalidateRect(hwndMain, NULL, TRUE);
}

/* show single digit on the single digit display */
void leds_show_1digit(u8 value) {
	sprintf(leds1_text, "%1d", value);
	InvalidateRect(hwndMain, NULL, TRUE);
}

/* --------------- Momentary toggle foot-switches: */

/* Poll up to 28 foot-switch toggles simultaneously.  PREV NEXT DEC  INC map to 28-31 bit positions. */
u32 fsw_poll() {
	return ((u32)pushed[0] << FSB_PRESET_1) |
		   ((u32)pushed[1] << FSB_PRESET_2) |
		   ((u32)pushed[2] << FSB_PRESET_3) |
		   ((u32)pushed[3] << FSB_PRESET_4) |
		   ((u32)pushed[4] << FSB_PREV) |
		   ((u32)pushed[5] << FSB_NEXT) |
		   ((u32)pushed[6] << FSB_DEC) |
		   ((u32)pushed[7] << FSB_INC);
}

/* Set currently active program foot-switch's LED indicator and disable all others */
void fsw_led_set_active(int idx) {
	fsw_active = idx;
	InvalidateRect(hwndMain, NULL, TRUE);
}

/* --------------- Slider switch: */

/* Poll the slider switch to see which mode we're in: */
u8 slider_poll() {
	return 0;
}

/* --------------- Data persistence functions: */

/* Gets number of stored banks */
u16 banks_count() {
	return 2;
}

/* Loads a bank into the specified arrays: */
void bank_load(u16 bank_index, char name[BANK_NAME_MAXLENGTH], u8 bank[BANK_PRESET_COUNT], u8 bankmap[BANK_MAP_COUNT], u8 *bankmap_count) {
	printf("LOAD: %4d\r\n", bank_index);
	switch (bank_index) {
		case 0:
			strncpy(name, "SOC1", BANK_NAME_MAXLENGTH);
			bank[0] = 0;
			bank[1] = 11;
			bank[2] = 22;
			bank[3] = 33;
			bankmap[0] = 0;
			bankmap[1] = 1;
			bankmap[2] = 0;
			bankmap[3] = 2;
			bankmap[4] = 0;
			bankmap[5] = 3;
			bankmap[6] = 0;
			*bankmap_count = 7;
			break;
		case 1:
			strncpy(name, "SOC2", BANK_NAME_MAXLENGTH);
			bank[0] = 44;
			bank[1] = 11;
			bank[2] = 22;
			bank[3] = 22;
			bankmap[0] = 0;
			bankmap[1] = 1;
			bankmap[2] = 2;
			*bankmap_count = 3;
			break;
	}
}

/* Load bank name for browsing through banks: */
void bank_loadname(u16 bank_index, char name[BANK_NAME_MAXLENGTH]) {
	switch (bank_index) {
		case 0:
			strncpy(name, "SOC1", BANK_NAME_MAXLENGTH);
			break;
		case 1:
			strncpy(name, "SOC2", BANK_NAME_MAXLENGTH);
			break;
	}
	printf("NAME: %4d = \"%.4s\"\r\n", bank_index, name);
}

/* Stores the programs back to the bank: */
void bank_store(u16 bank_index, u8 bank[BANK_PRESET_COUNT]) {
	printf("STOR: %4d = {0x%02X, 0x%02X, 0x%02X, 0x%02X}\r\n", bank_index, bank[0], bank[1], bank[2], bank[3]);
}

/* --------------- MIDI I/O functions: */

/* Send a single MIDI byte. */
void midi_send_byte(u8 data) {
	printf("MIDI: 0x%02X\r\n", data);
}

/* Send formatted MIDI commands.

	0 <= cmd <= F       - MIDI command
	0 <= channel <= F   - MIDI channel to send command to
	00 <= data1 <= FF   - first data byte of MIDI command
	00 <= data2 <= FF   - second (optional) data byte of MIDI command
*/
void midi_send_cmd1(u8 cmd, u8 channel, u8 data1) {
	midi_send_byte(((cmd & 0xF) << 4) | (channel & 0xF));
	midi_send_byte(data1);
}

void midi_send_cmd2(u8 cmd, u8 channel, u8 data1, u8 data2) {
	midi_send_byte(((cmd & 0xF) << 4) | (channel & 0xF));
	midi_send_byte(data1);
	midi_send_byte(data2);
}
