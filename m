Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646EA2E737B;
	Mon, 20 Jul 2026 02:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784516122; cv=none; b=O2u1PpQIHfs5M3l5qiiDkspN4FZszSH2J8UjdV3NJ5ihBSKB8Lip9HQbpF9bwtPCbl4YLe73vvcu+cVpxpM8exGyguczNIl5WFtsw0klPhFBY8eDQJWhEA1oBTiu+nkG6rFD1EbvYnCrlEQGoM3uMNQS8WEkQJ2MJGfC599svOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784516122; c=relaxed/simple;
	bh=Hnx3nUFwWNFb9QrcHto2TpdHhX3z/NPkPflALtOS0gM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O/dGyq85kHBtFJNM5u9Gu68lZFu7C9cn/cXYSHQrprPcIOMyhl5vzGpdO3u6LVbj/Bda1j6FMYJLatx4Yl+HNm88ZN0OUtvHMikcGvdzn787GHm6PPtwwVpfXqqwWF/TcRp9GaopmKIZrxzQ4vo4f6wDuG+apSnef+DlGVc1Hjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6646be8c83e611f1aa26b74ffac11d73-20260720
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6044bb1f-1f7a-4318-b6eb-9931124d68a0,IP:0,U
	RL:0,TC:0,Content:-5,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-30
X-CID-META: VersionHash:e7bac3a,CLOUDID:3aaa4d126f85d8a5ddab220b32a95e64,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:2,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6646be8c83e611f1aa26b74ffac11d73-20260720
X-User: yanlonglong@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanlonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 427877823; Mon, 20 Jul 2026 10:55:00 +0800
From: longlong yan <yanlonglong@kylinos.cn>
To: jarkko@kernel.org,
	dave.hansen@linux.intel.com,
	shuah@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: longlong yan <yanlonglong@kylinos.cn>
Subject: [PATCH] selftests/sgx: use MAP_FAILED for mmap error check
Date: Mon, 20 Jul 2026 10:54:43 +0800
Message-ID: <20260720025443.506-1-yanlonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1.windows.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the direct comparison with (void *)-1 with the standard
MAP_FAILED macro when checking mmap()

Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
---
 tools/testing/selftests/sgx/load.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index c9f658e44de6..6204ab0bae19 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -202,7 +202,7 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
 	}
 
 	ptr = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, fd, 0);
-	if (ptr == (void *)-1) {
+	if (ptr == MAP_FAILED) {
 		perror("mmap for read");
 		goto err;
 	}
@@ -215,7 +215,7 @@ bool encl_load(const char *path, struct encl *encl, unsigned long heap_size)
 " If so, remount it executable: mount -o remount,exec /dev\n\n"
 
 	ptr = mmap(NULL, PAGE_SIZE, PROT_EXEC, MAP_SHARED, fd, 0);
-	if (ptr == (void *)-1) {
+	if (ptr == MAP_FAILED) {
 		fprintf(stderr, ERR_MSG);
 		goto err;
 	}
-- 
2.43.0

