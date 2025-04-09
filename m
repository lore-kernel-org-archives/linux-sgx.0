Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B471A315A
	for <linux-sgx@vger.kernel.org>; Wed,  9 Apr 2025 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744217741; cv=none; b=ZWsf5fkserzGIKmll8kAXaRopJFapJ0G0DNYDxhpUOW2HOTdQfkrteVLjfXuChJeBYk3OMm7U81QGmMEP5KbNgSixM9stbcqlidKkYTHgZBDXJ6E/bo76AfiF+xccPSwLjJ+izV7v1wosPDYiP/+ZZ/iWXOCuK5+y1SGyN+pEqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744217741; c=relaxed/simple;
	bh=4gBqLRCjG5WlF4pc12HR6xav3S0nBYhW+3KH2xBP+Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=TnFFo1qcS5sWSQBuB14fagtcEoIIefCb+NEESRyYLsMNRFNKwycgGqWqN0MRWNfaoJB9d0s94AkaxGS06zNZr001zFBQLCceFo81pHkjFqp9aUsjLLfGsY3ojqHm9J9FEhWJw/FVnvWOxQq/fbVbm9y0FvEK6I55+DxXRJktd/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rfom1+Ro; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rfom1+Ro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744217738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=erfq7737JXLCXKwNvQFnodKJdhZsFHJKAqncod7mqSE=;
	b=Rfom1+RobeBbtXG3OGcJWXXxQuV/oPNhM6E/lIvXrNVgKfNmE9nzCCfCeIwM+rXeluErUG
	dOJTaIWcciCq7BHD3S1/4pI4FCjWM2iWXRn1VtfiO0PncjBy/ioW6lIG+M3W1wIayuP8WT
	B42pwfv6WYdoo5vI+j+mFeOYj4IX8Qs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-J8L3kIAyMeu2u__Y5JiTBA-1; Wed,
 09 Apr 2025 12:55:37 -0400
X-MC-Unique: J8L3kIAyMeu2u__Y5JiTBA-1
X-Mimecast-MFC-AGG-ID: J8L3kIAyMeu2u__Y5JiTBA_1744217736
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9FCA180035E;
	Wed,  9 Apr 2025 16:55:35 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.22.33])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5BE5618009BC;
	Wed,  9 Apr 2025 16:55:31 +0000 (UTC)
From: Vladis Dronov <vdronov@redhat.com>
To: linux-sgx@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] selftests/sgx: Fix an enclave built with extended instructions
Date: Wed,  9 Apr 2025 18:55:10 +0200
Message-ID: <20250409165510.23066-1-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Creating an enclave with xfrm == 3 disables extended CPU states and instruction
sets, like AVX2 and AVX512 inside the enclave. Thus the enclave code has to be
built with a compiler which does not produce instructions from the extended
instruction sets. Nevertheless certain Linux distributions confgure a compiler
so it produces extended instructions by default ("--with-arch_64=x86-64-v3" for
gcc). Thus an enclave code from test_encl.c is built with extended instructions
and an enclave execution hits the #UD exception (note exception_vector == 6):

    # ./test_sgx
    ...
    #  RUN           enclave.unclobbered_vdso_oversubscribed_remove ...
    # main.c:481:unclobbered_vdso_oversubscribed_remove:Expected self->run.exception_vector (6) == 0 (0)
    # main.c:485:unclobbered_vdso_oversubscribed_remove:Expected self->run.function (3) == EEXIT (4)
    # unclobbered_vdso_oversubscribed_remove: Test terminated by assertion
    #          FAIL  enclave.unclobbered_vdso_oversubscribed_remove
    not ok 3 enclave.unclobbered_vdso_oversubscribed_remove

Fix this by adding "-mno-avx" to ENCL_CFLAGS in Makefile. Add some comments
about this to code locations where enclave's xfrm field is set.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
an out-of-commit-message note:

I would greatly appreciate if someone reviews and possibly fixes my wording
of the commit message and the code comments.

 tools/testing/selftests/sgx/Makefile    | 2 +-
 tools/testing/selftests/sgx/load.c      | 8 +++++++-
 tools/testing/selftests/sgx/sigstruct.c | 6 ++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 03b5e13b872b..ab2561b4456d 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -15,7 +15,7 @@ INCLUDES := -I$(top_srcdir)/tools/include
 HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC $(CFLAGS)
 HOST_LDFLAGS := -z noexecstack -lcrypto
 ENCL_CFLAGS += -Wall -Werror -static-pie -nostdlib -ffreestanding -fPIE \
-	       -fno-stack-protector -mrdrnd $(INCLUDES)
+	       -fno-stack-protector -mrdrnd -mno-avx $(INCLUDES)
 ENCL_LDFLAGS := -Wl,-T,test_encl.lds,--build-id=none
 
 ifeq ($(CAN_BUILD_X86_64), 1)
diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index c9f658e44de6..79946ca8f1a5 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -88,10 +88,16 @@ static bool encl_ioc_create(struct encl *encl)
 	memset(secs, 0, sizeof(*secs));
 	secs->ssa_frame_size = 1;
 	secs->attributes = SGX_ATTR_MODE64BIT;
-	secs->xfrm = 3;
 	secs->base = encl->encl_base;
 	secs->size = encl->encl_size;
 
+	/*
+	 * Setting xfrm to 3 disables extended CPU states and instruction sets
+	 * like AVX2 inside the enclave. Thus the enclave code has to be built
+	 * without instructions from extended instruction sets (-mno-avx).
+	 */
+	secs->xfrm = 3;
+
 	ioc.src = (unsigned long)secs;
 	rc = ioctl(encl->fd, SGX_IOC_ENCLAVE_CREATE, &ioc);
 	if (rc) {
diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index d73b29becf5b..f548392a2fee 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -331,6 +331,12 @@ bool encl_measure(struct encl *encl)
 	sigstruct->header.header2[1] = header2[1];
 	sigstruct->exponent = 3;
 	sigstruct->body.attributes = SGX_ATTR_MODE64BIT;
+
+	/*
+	 * Setting xfrm to 3 disables extended CPU states and instruction sets
+	 * like AVX2 inside the enclave. Thus the enclave code has to be built
+	 * without instructions from extended instruction sets (-mno-avx).
+	 */
 	sigstruct->body.xfrm = 3;
 
 	/* sanity check */
-- 
2.49.0

