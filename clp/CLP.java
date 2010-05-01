import com.sun.jna.Library;
import java.nio.ByteBuffer;
import com.sun.jna.Pointer;
import java.nio.IntBuffer;
import com.sun.jna.NativeLibrary;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.Native;

public interface CLP extends Library {
	/**
	 * Original signature : <code>int clp_init()</code><br>
	 */
	int clp_init();
	/**
	 * Original signature : <code>char* clp_ver()</code><br>
	 */
	String clp_ver();
	/**
	 * Original signature : <code>int clp_pos(int)</code><br>
	 */
	int clp_pos(int id);
	/**
	 * Original signature : <code>void clp_label(int, char*)</code><br>
	 */
	void clp_label(int id, ByteBuffer out);
	/**
	 * Original signature : <code>void clp_bform(int, char*)</code><br>
	 */
	void clp_bform(int id, ByteBuffer out);
	/**
	 * Original signature : <code>void clp_forms(int, char*)</code><br>
	 */
	void clp_forms(int id, ByteBuffer out);
	/**
	 * Original signature : <code>void clp_formv(int, char*)</code><br>
	 */
	void clp_formv(int id, ByteBuffer out);
	/**
	 * Original signature : <code>void clp_vec(int, const char*, int*, int*)</code><br>
	 */
	void clp_vec(int id, java.lang.String inp, IntBuffer out, IntBuffer num);
	/**
	 * Original signature : <code>void clp_rec(const char*, int*, int*)</code><br>
	 */
	void clp_rec(java.lang.String inp, IntBuffer out, IntBuffer num);
	/**
	 * Original signature : <code>void clp_tag1(const char*, char*)</code><br>
	 */
	void clp_tag1(java.lang.String inp, ByteBuffer out);
}
