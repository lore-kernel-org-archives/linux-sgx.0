Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529162;
	b=u48HOGbCVLmKj4ofzTRi91yW053zPzOeg6+deFJRO7culDXosL+U7FRY2dBTbAFYVt+A
	 ZGCZRAyhbur9xz7aov+KyYGGgNVNTa537ONK9lmPi8JQdXWU95GPBXPqj2iNttLM1W0pg
	 F+P6XaZ1Vz5Q4gAkowrjGIqNj3HL9GvZv5ZJikSZcYgz+KHVjJ1giQhJlIe3VDI2o+YXw
	 uZCjmeViloq5x1nI5OwyhRScACnx893TyXtHsBH18pvQ+2P24YsPZCxyGPjzm5pEj03EB
	 lQGjVQPIADMYoDZq2oyP4WYpxqtd+CAcfL1Mw2H7es4vdCvdcQ7op+SSEjDG1hGiH2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529162;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Xz3JZynnSnHv9nbaBuLzugbnS2n4YlzDZoTaQ5Jmb3s=;
	b=PaAJY0+4Q9SoOxVI/Rz/0++KIIvBMcMTpAC1yf6DcKC2p5uE9JVi90vs8Pv8MMxF9Mo5
	 U4jDBBOKXtdkwsK/KVbji25xuFx7DjuMVe2ynWiVP4sKueEm46AeUE4Mt/Pjubhc4l9Ai
	 haludbNNBFu4PpZ1i5sgYfF4pQYMalqJUWsFjKskE+KvOUoN88Nl4PdFRhbtgtzwhuNWU
	 FlF+ZoLfiK7TxH89kfMnXAbVYgcduNwLvsKRV+eA3NAgsKCDrj7aPgahEkVcWkVbjWBYw
	 7w7VnFv/TgK+1yNzoK3Kp7O15B2NRC0VVJTE5rLhVVrlDqiItFWJlQYho9SgarqPkNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vw2xmPmJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F4A606A332;
	Tue, 24 Nov 2026 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vw2xmPmJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D1A1F000F4;
	Tue, 24 Nov 2026 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529161;
	bh=Xz3JZynnSnHv9nbaBuLzugbnS2n4YlzDZoTaQ5Jmb3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vw2xmPmJQCeYDCDMmY/gA4vXIgOcUqZ7mdGwQ4g6z3pnvvJhKlcivb9Ce4f0sbnTQ
	 /LndZy836pXWzpMoLqWeZGs9kmkzTgLXcgsncJe3Sgpdznr0vgXQzStws0T7CrNols
	 q1XAlcfii8MGbZg3YqL/5zFgRywif4itMirDlCfnjGE2g4m0/iyeR05TfxYIiqC5a0
	 DDMZDCaGN/By4BuHe6Z1IASCC5aG309wloC7i0Ca5r1ONw5oczFjrDjXSQ494eMMg3
	 FjIOXo8c8eDXjpcMCmzTzhJlUYc04w8gDefCsx1HPg1GPPPk2po0LDn546RnUDJ7Pr
	 ImjOyb0Tb2I+Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:53 +0000
Subject: [PATCH v2 10/13] tee: convert shm mmap hook to mmap_prepare
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-mmap_prepare-v2-10-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
 Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
 Ryan Chen <ryan_chen@aspeedtech.com>, 
 Billy Tsai <billy_tsai@aspeedtech.com>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 Scott Branden <scott.branden@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Richard Cochran <richardcochran@gmail.com>, 
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: ljs@kernel.org, xen-devel@lists.xenproject.org, 
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
 selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org, 
 linux-mm@kvack.org, Jens Wiklander <jens.wiklander@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1749; i=ljs@kernel.org;
 h=from:subject:message-id; bh=L1Gu/KToKofd3UZS/FEjh2Yr3KNqQvPetiiaaibWgBg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ0r4Zx46snTdPtHW8+tnNGfPK/BmSd/qfVBuc/PZ5
 DC+i1MbO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRh4sZ/hfVtRWlirr57Fnf
 uvle5BG7nX7vJj9r2fnnlqD/A2Ph1jyG/2n68j8PLpb/+vLeF/GV5Zc8dn8rttT49MeoOuz91Xe
 swswA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
PFN remap mmap action to map the shared memory.

Reviewed-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/tee/tee_shm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index daa4af1e089e..8fcbf0232aeb 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -567,10 +567,9 @@ static int tee_shm_fop_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
+static int tee_shm_fop_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct tee_shm *shm = filp->private_data;
-	size_t size = vma->vm_end - vma->vm_start;
+	struct tee_shm *shm = desc->file->private_data;
 
 	/* Refuse sharing shared memory provided by application */
 	if (shm->flags & TEE_SHM_USER_MAPPED)
@@ -580,17 +579,18 @@ static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	/* check for overflowing the buffer's size */
-	if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) > shm->size >> PAGE_SHIFT)
 		return -EINVAL;
 
-	return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHIFT,
-			       size, vma->vm_page_prot);
+	mmap_action_remap_full(desc, shm->paddr >> PAGE_SHIFT);
+
+	return 0;
 }
 
 static const struct file_operations tee_shm_fops = {
 	.owner = THIS_MODULE,
 	.release = tee_shm_fop_release,
-	.mmap = tee_shm_fop_mmap,
+	.mmap_prepare = tee_shm_fop_mmap_prepare,
 };
 
 /**

-- 
2.56.1

