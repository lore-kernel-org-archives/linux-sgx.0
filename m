From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Darren Hart
	<dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v12 12/13] platform/x86: ptrace() support for the SGX driver
Date: Tue, 3 Jul 2018 21:19:57 +0300
Message-ID: <20180703182118.15024-13-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Implemented VMA callbacks in order to ptrace() debug enclaves. With
debug enclaves data can be read and write the memory word at a time by
using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/platform/x86/intel_sgx/sgx_encl.c |   2 +-
 drivers/platform/x86/intel_sgx/sgx_vma.c  | 116 ++++++++++++++++++++++
 2 files changed, 117 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel_sgx/sgx_encl.c b/drivers/platform/x86/intel_sgx/sgx_encl.c
index e3d7fa885489..20cd9ff7dd75 100644
--- a/drivers/platform/x86/intel_sgx/sgx_encl.c
+++ b/drivers/platform/x86/intel_sgx/sgx_encl.c
@@ -954,7 +954,7 @@ int sgx_encl_load_page(struct sgx_encl_page *encl_page,
 	ret = __eldu(&pginfo, epc_ptr, va_ptr + va_offset);
 	if (ret) {
 		sgx_err(encl, "ELDU returned %d\n", ret);
-		ret = -EFAULT;
+		ret = ENCLS_TO_ERR(ret);
 	}
 
 	kunmap_atomic((void *)(unsigned long)(pginfo.pcmd - pcmd_offset));
diff --git a/drivers/platform/x86/intel_sgx/sgx_vma.c b/drivers/platform/x86/intel_sgx/sgx_vma.c
index cc0993b4fd40..3a856e40c82c 100644
--- a/drivers/platform/x86/intel_sgx/sgx_vma.c
+++ b/drivers/platform/x86/intel_sgx/sgx_vma.c
@@ -51,8 +51,124 @@ static int sgx_vma_fault(struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 }
 
+static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset;
+	void *ptr;
+	int ret;
+
+	offset = addr & ~PAGE_MASK;
+
+	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
+            offset > offsetof(struct sgx_tcs, gslimit))
+		return -ECANCELED;
+
+	ptr = sgx_get_page(page->epc_page);
+	ret = __edbgrd((unsigned long)ptr + offset, data);
+	sgx_put_page(ptr);
+	if (ret) {
+		sgx_dbg(encl, "EDBGRD returned %d\n", ret);
+		return ENCLS_TO_ERR(ret);
+	}
+
+	return 0;
+}
+
+static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
+		      unsigned long addr, void *data)
+{
+	unsigned long offset;
+	void *ptr;
+	int ret;
+
+	offset = addr & ~PAGE_MASK;
+
+	/* Writing anything else than flags will cause #GP */
+	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
+	    offset != offsetof(struct sgx_tcs, flags))
+		return -ECANCELED;
+
+	ptr = sgx_get_page(page->epc_page);
+	ret = __edbgwr((unsigned long)ptr + offset, data);
+	sgx_put_page(ptr);
+	if (ret) {
+		sgx_dbg(encl, "EDBGWR returned %d\n", ret);
+		return ENCLS_TO_ERR(ret);
+	}
+
+	return 0;
+}
+
+static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
+			  void *buf, int len, int write)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_page *entry = NULL;
+	unsigned long align;
+	char data[sizeof(unsigned long)];
+	int offset;
+	int cnt;
+	int ret = 0;
+	int i;
+
+	/* If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return -EFAULT;
+
+	if (!(encl->flags & SGX_ENCL_DEBUG) ||
+	    !(encl->flags & SGX_ENCL_INITIALIZED) ||
+	    (encl->flags & SGX_ENCL_DEAD))
+		return -EFAULT;
+
+	for (i = 0; i < len; i += cnt) {
+		if (!entry || !((addr + i) & (PAGE_SIZE - 1))) {
+			if (entry)
+				entry->desc &= ~SGX_ENCL_PAGE_RESERVED;
+
+			entry = sgx_fault_page(vma, (addr + i) & PAGE_MASK,
+					       true);
+			if (IS_ERR(entry)) {
+				ret = PTR_ERR(entry);
+				entry = NULL;
+				break;
+			}
+		}
+
+		/* Locking is not needed because only immutable fields of the
+		 * page are accessed and page itself is reserved so that it
+		 * cannot be swapped out in the middle.
+		 */
+
+		align = ALIGN_DOWN(addr + i, sizeof(unsigned long));
+		offset = (addr + i) & (sizeof(unsigned long) - 1);
+		cnt = sizeof(unsigned long) - offset;
+		cnt = min(cnt, len - i);
+
+		ret = sgx_edbgrd(encl, entry, align, data);
+		if (ret)
+			break;
+		if (write) {
+			memcpy(data + offset, buf + i, cnt);
+			ret = sgx_edbgwr(encl, entry, align, data);
+			if (ret)
+				break;
+		}
+		else
+			memcpy(buf + i,data + offset, cnt);
+	}
+
+	if (entry)
+		entry->desc &= ~SGX_ENCL_PAGE_RESERVED;
+
+	return (ret < 0 && ret != -ECANCELED) ? ret : i;
+}
+
 const struct vm_operations_struct sgx_vm_ops = {
 	.close = sgx_vma_close,
 	.open = sgx_vma_open,
 	.fault = sgx_vma_fault,
+	.access = sgx_vma_access,
 };
-- 
2.17.1
