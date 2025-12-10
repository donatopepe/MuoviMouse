import ctypes
import random
import time

# Minimal mouse "jiggle" to keep the session active without noticeable movement.
user32 = ctypes.windll.user32


class POINT(ctypes.Structure):
    _fields_ = [("x", ctypes.c_long), ("y", ctypes.c_long)]


def get_cursor_pos():
    point = POINT()
    user32.GetCursorPos(ctypes.byref(point))
    return point.x, point.y


def set_cursor_pos(x, y):
    user32.SetCursorPos(int(x), int(y))


def jiggle(
    check_interval_seconds=2,
    idle_seconds=30,
    offset_pixels=12,
    pulse_seconds=0.5,
):
    last_pos = get_cursor_pos()
    last_move = time.time()
    print(
        f"Mouse keep-alive armed: jiggles after {idle_seconds}s idle, offset {offset_pixels}px. Ctrl+C to stop."
    )

    try:
        while True:
            current_pos = get_cursor_pos()
            if current_pos != last_pos:
                last_move = time.time()
                last_pos = current_pos

            idle_duration = time.time() - last_move
            if idle_duration >= idle_seconds:
                dx = random.randint(-offset_pixels, offset_pixels)
                dy = random.randint(-offset_pixels, offset_pixels)
                while dx == 0 and dy == 0:
                    dx = random.randint(-offset_pixels, offset_pixels)
                    dy = random.randint(-offset_pixels, offset_pixels)

                print(
                    f"Idle for {int(idle_duration)}s -> jiggle {offset_pixels}px dir ({dx},{dy})."
                )
                set_cursor_pos(current_pos[0] + dx, current_pos[1] + dy)
                time.sleep(pulse_seconds)
                set_cursor_pos(*current_pos)
                last_move = time.time()
                last_pos = current_pos

            time.sleep(check_interval_seconds)
    except KeyboardInterrupt:
        print("Mouse keep-alive stopped.")


if __name__ == "__main__":
    jiggle()
