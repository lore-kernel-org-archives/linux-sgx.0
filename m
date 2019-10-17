Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C21FA372C
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 046C621A4C
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 03:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392128AbfJQDDq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:16893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392091AbfJQDDq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 23:03:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 20:03:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,306,1566889200"; 
   d="scan'208";a="195026851"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 16 Oct 2019 20:03:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v2? v2 10/14] selftests/x86/sgx: Handle setup failures via kselftest assertions
Date:   Wed, 16 Oct 2019 20:03:36 -0700
Message-Id: <20191017030340.18301-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017030340.18301-1-sean.j.christopherson@intel.com>
References: <20191017030340.18301-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use kselftest's assertion operators to report errors and exit instead of
propagating errors up the stack.  Using assertions reduces code and
provides more detailed error messages, and all existing errors lead to
exit(1) anyways, i.e. asserting isn't blocking forward progress.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 174 +++++++++----------------
 1 file changed, 58 insertions(+), 116 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index f1bd74913ec3..24647050657a 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -51,6 +51,14 @@ do {									      \
 	}								      \
 } while (0)
 
+#define ASSERT_RAW(_cond, fmt, ...)					\
+do {									\
+	if (!(_cond)) {							\
+		fprintf(stderr, "  %s:%u: ", __FILE__, __LINE__);	\
+		ksft_exit_fail_msg(fmt, ##__VA_ARGS__);			\
+	}								\
+} while (0)
+
 #define RUN_TEST(test_name)						\
 ({									\
 	passed = true;							\
@@ -100,23 +108,18 @@ static void *vdso_get_dyn(void *addr, Elf64_Dyn *dyntab, Elf64_Sxword tag)
 	return NULL;
 }
 
-static bool vdso_get_symtab(void *addr, struct vdso_symtab *symtab)
+static void vdso_get_symtab(void *addr, struct vdso_symtab *symtab)
 {
 	Elf64_Dyn *dyntab = vdso_get_dyntab(addr);
 
 	symtab->elf_symtab = vdso_get_dyn(addr, dyntab, DT_SYMTAB);
-	if (!symtab->elf_symtab)
-		return false;
+	ASSERT_NE(symtab->elf_symtab, NULL);
 
 	symtab->elf_symstrtab = vdso_get_dyn(addr, dyntab, DT_STRTAB);
-	if (!symtab->elf_symstrtab)
-		return false;
+	ASSERT_NE(symtab->elf_symstrtab, NULL);
 
 	symtab->elf_hashtab = vdso_get_dyn(addr, dyntab, DT_HASH);
-	if (!symtab->elf_hashtab)
-		return false;
-
-	return true;
+	ASSERT_NE(symtab->elf_hashtab, NULL);
 }
 
 static unsigned long elf_sym_hash(const char *name)
@@ -154,7 +157,7 @@ static Elf64_Sym *vdso_symtab_get(struct vdso_symtab *symtab, const char *name)
 	return NULL;
 }
 
-static bool encl_create(int dev_fd, unsigned long bin_size,
+static void encl_create(int dev_fd, unsigned long bin_size,
 			struct sgx_secs *secs)
 {
 	struct sgx_enclave_create ioc;
@@ -170,10 +173,7 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 		secs->size <<= 1;
 
 	area = mmap(NULL, secs->size * 2, PROT_NONE, MAP_SHARED, dev_fd, 0);
-	if (area == MAP_FAILED) {
-		perror("mmap");
-		return false;
-	}
+	ASSERT_NE(area, MAP_FAILED);
 
 	secs->base = ((uint64_t)area + secs->size - 1) & ~(secs->size - 1);
 
@@ -183,16 +183,11 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 
 	ioc.src = (unsigned long)secs;
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_CREATE, &ioc);
-	if (rc) {
-		fprintf(stderr, "ECREATE failed rc=%d, err=%d.\n", rc, errno);
-		munmap((void *)secs->base, secs->size);
-		return false;
-	}
-
-	return true;
+	ASSERT_RAW(!rc, "ECREATE failed rc=%d, errno=%s.\n",
+		    rc, strerror(errno));
 }
 
-static bool encl_add_page(int dev_fd, unsigned long addr, void *data,
+static void encl_add_page(int dev_fd, unsigned long addr, void *data,
 			  uint64_t flags)
 {
 	struct sgx_enclave_add_page ioc;
@@ -209,15 +204,10 @@ static bool encl_add_page(int dev_fd, unsigned long addr, void *data,
 	memset(ioc.reserved, 0, sizeof(ioc.reserved));
 
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_ADD_PAGE, &ioc);
-	if (rc) {
-		fprintf(stderr, "EADD failed rc=%d.\n", rc);
-		return false;
-	}
-
-	return true;
+	ASSERT_RAW(!rc, "EADD failed rc=%d.\n", rc);
 }
 
-static bool encl_build(struct sgx_secs *secs, void *bin,
+static void encl_build(struct sgx_secs *secs, void *bin,
 		       unsigned long bin_size, struct sgx_sigstruct *sigstruct)
 {
 	struct sgx_enclave_init ioc;
@@ -228,13 +218,10 @@ static bool encl_build(struct sgx_secs *secs, void *bin,
 	int rc;
 
 	dev_fd = open("/dev/sgx/enclave", O_RDWR);
-	if (dev_fd < 0) {
-		fprintf(stderr, "Unable to open /dev/sgx\n");
-		return false;
-	}
+	ASSERT_RAW(dev_fd >= 0, "Unable to open /dev/sgx: %s\n",
+		   strerror(errno));
 
-	if (!encl_create(dev_fd, bin_size, secs))
-		goto out_dev_fd;
+	encl_create(dev_fd, bin_size, secs);
 
 	for (offset = 0; offset < bin_size; offset += 0x1000) {
 		if (!offset)
@@ -243,131 +230,90 @@ static bool encl_build(struct sgx_secs *secs, void *bin,
 			flags = SGX_SECINFO_REG | SGX_SECINFO_R |
 				SGX_SECINFO_W | SGX_SECINFO_X;
 
-		if (!encl_add_page(dev_fd, secs->base + offset,
-				   bin + offset, flags))
-			goto out_map;
+		encl_add_page(dev_fd, secs->base + offset, bin + offset, flags);
 	}
 
 	ioc.sigstruct = (uint64_t)sigstruct;
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
-	if (rc) {
-		printf("EINIT failed rc=%d\n", rc);
-		goto out_map;
-	}
+	ASSERT_RAW(!rc, "EINIT failed rc=%d, errno=%s.\n", rc, strerror(errno));
 
 	addr = mmap((void *)secs->base, PAGE_SIZE, PROT_READ | PROT_WRITE,
 		    MAP_SHARED | MAP_FIXED, dev_fd, 0);
-	if (addr == MAP_FAILED) {
-		fprintf(stderr, "mmap() failed on TCS, errno=%d.\n", errno);
-		return false;
-	}
+	ASSERT_RAW(addr != MAP_FAILED, "mmap() failed on TCS: %s\n",
+		    strerror(errno));
 
 	addr = mmap((void *)(secs->base + PAGE_SIZE), bin_size - PAGE_SIZE,
 		    PROT_READ | PROT_WRITE | PROT_EXEC,
 		    MAP_SHARED | MAP_FIXED, dev_fd, 0);
-	if (addr == MAP_FAILED) {
-		fprintf(stderr, "mmap() failed, errno=%d.\n", errno);
-		return false;
-	}
+	ASSERT_RAW(addr != MAP_FAILED, "mmap() failed on REG page: %s\n",
+		    strerror(errno));
 
 	close(dev_fd);
-	return true;
-out_map:
-	munmap((void *)secs->base, secs->size);
-out_dev_fd:
-	close(dev_fd);
-	return false;
 }
 
-static bool get_file_size(const char *path, off_t *bin_size)
+static off_t get_file_size(const char *path)
 {
 	struct stat sb;
 	int ret;
 
 	ret = stat(path, &sb);
-	if (ret) {
-		perror("stat");
-		return false;
-	}
-
-	if (!sb.st_size || sb.st_size & 0xfff) {
-		fprintf(stderr, "Invalid blob size %lu\n", sb.st_size);
-		return false;
-	}
-
-	*bin_size = sb.st_size;
-	return true;
+	ASSERT_RAW(!ret, "stat() %s failed: %s\n", path, strerror(errno));
+
+	ASSERT_RAW(sb.st_size && !(sb.st_size & 0xfff),
+		    "Invalid blob size: %llu", sb.st_size);
+
+	return sb.st_size;
 }
 
-static bool encl_data_map(const char *path, void **bin, off_t *bin_size)
+static void *encl_data_map(const char *path, off_t *bin_size)
 {
+	void *bin;
 	int fd;
 
 	fd = open(path, O_RDONLY);
-	if (fd == -1)  {
-		fprintf(stderr, "open() %s failed, errno=%d.\n", path, errno);
-		return false;
-	}
+	ASSERT_RAW(fd >= 0, "open() %s failed: %s\n", path, strerror(errno));
 
-	if (!get_file_size(path, bin_size))
-		goto err_out;
+	*bin_size = get_file_size(path);
 
-	*bin = mmap(NULL, *bin_size, PROT_READ, MAP_PRIVATE, fd, 0);
-	if (*bin == MAP_FAILED) {
-		fprintf(stderr, "mmap() %s failed, errno=%d.\n", path, errno);
-		goto err_out;
-	}
+	bin = mmap(NULL, *bin_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	ASSERT_RAW(bin != MAP_FAILED, "mmap() %s failed: %s\n",
+		    path, strerror(errno));
 
 	close(fd);
-	return true;
-
-err_out:
-	close(fd);
-	return false;
+	return bin;
 }
 
-static bool load_sigstruct(const char *path, void *sigstruct)
+static void load_sigstruct(const char *path, struct sgx_sigstruct *sigstruct)
 {
+	ssize_t nr_read;
 	int fd;
 
 	fd = open(path, O_RDONLY);
-	if (fd == -1)  {
-		fprintf(stderr, "open() %s failed, errno=%d.\n", path, errno);
-		return false;
-	}
-
-	if (read(fd, sigstruct, sizeof(struct sgx_sigstruct)) !=
-	    sizeof(struct sgx_sigstruct)) {
-		fprintf(stderr, "read() %s failed, errno=%d.\n", path, errno);
-		close(fd);
-		return false;
-	}
+	ASSERT_RAW(fd > 0, "open() %s failed: %s\n", path, strerror(errno));
+
+	nr_read = read(fd, sigstruct, sizeof(struct sgx_sigstruct));
+	ASSERT_RAW(nr_read == sizeof(struct sgx_sigstruct),
+		    "read() %s failed: %s\n", path, strerror(errno));
 
 	close(fd);
-	return true;
 }
 
-static bool setup_vdso(void)
+static void setup_vdso(void)
 {
 	struct vdso_symtab symtab;
 	Elf64_Sym *eenter_sym;
 	void *addr;
 
 	addr = vdso_get_base_addr();
-	if (!addr)
-		return false;
+	ASSERT_NE(addr, NULL);
 
-	if (!vdso_get_symtab(addr, &symtab))
-		return false;
+	vdso_get_symtab(addr, &symtab);
 
 	eenter_sym = vdso_symtab_get(&symtab, "__vdso_sgx_enter_enclave");
-	if (!eenter_sym)
-		return false;
+	ASSERT_NE(eenter_sym, NULL);
 
 	/* eenter is used by sgx_call_vdso() to call into the vDSO. */
 	eenter = addr + eenter_sym->st_value;
-
-	return true;
 }
 
 static void test_sgx_basic(struct sgx_secs *secs)
@@ -400,19 +346,15 @@ int main(int argc, char *argv[], char *envp[])
 	ksft_print_header();
 	ksft_set_plan(2);
 
-	if (!encl_data_map("encl.bin", &bin, &bin_size))
-		exit(1);
+	bin = encl_data_map("encl.bin", &bin_size);
 
-	if (!load_sigstruct("encl.ss", &sigstruct))
-		exit(1);
+	load_sigstruct("encl.ss", &sigstruct);
 
-	if (!encl_build(&secs, bin, bin_size, &sigstruct))
-		exit(1);
+	encl_build(&secs, bin, bin_size, &sigstruct);
 
 	RUN_TEST(test_sgx_basic);
 
-	if (!setup_vdso())
-		exit(1);
+	setup_vdso();
 
 	RUN_TEST(test_sgx_vdso);
 
-- 
2.22.0

