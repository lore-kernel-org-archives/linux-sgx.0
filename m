Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529193;
	b=GCstuRpTfLKTsDCzQPIOCm1C92uAimCOiiKgD+XhNleMzM4nq3ctT5hO3jp8v/FoSTm9
	 6PH04tdwS2M0xNJPu9H2T4g1DCIG2WbbOdRQ6rJSbWWn/S3gGX6Zjqh57t9fNJIsZeH5i
	 B8lgs3cJr2UAjBYbkMTmVe+3f6Z9qKfRJBLrVEv3eTbEnzV2YkX/I7Fm/+QKRHeXTTzqC
	 6xi64gxrAHz7I7Z4GEIQP9kzNeGc7lB28O1+qYGmJFo2NHaMPUmOn4FbYFn2qZ7NdYGTh
	 Se0QuFACYbabUxrIFiJ3ec9mfWoHiy8DGoSu6rnY/6k5QPGWsHu0tcqaxKFN8RPyvrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529193;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=hiMN3N/C7dD03jnJATzFgmGeR7RslpdlQJN0uDpFXN4=;
	b=JAxdeC/B43VqGSEJb5zFwIpEJPD/kDUhFbFVhxW8X6Q3nGMGQsmMXu+V6hslQPhTtqOf
	 l3P1APWPwwLPg9GO0z7P8qpvwzNPl12/ZZlJsLHajZpnjZKSQ+vqwibVKkKL+Us50FWW0
	 7seW+gORxMAl5VLSgJhYmVLozrk8eGaoDVpTBtlV3moj1jzZMABjXlzxMQLVNRAmVa/26
	 dH6Go+qKwge637JvfEtM3BD2vVpi2nVSKtWdUJQ8x1eFF0a6XUM/hCDu+bHaOa1CqZxH/
	 1Tuq61VSqzuGXBu5TMD+6ZmoF86Hb4J27wn0XhkLu/VyC3BWUYqT9okcRdzurowlJkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQjYxltb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAE8606A339;
	Tue, 24 Nov 2026 14:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQjYxltb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108161F000D8;
	Tue, 24 Nov 2026 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529193;
	bh=hiMN3N/C7dD03jnJATzFgmGeR7RslpdlQJN0uDpFXN4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MQjYxltb9Lfnf6aDL5OYh7Tos6dJojDYdjybWJGWVNjJ6hrbfTJ8ZPZVPi5MfppI5
	 pdUQnhlSUzUdj9WwvNDPmbRseMIDLkEdFaRFtoVatla5/Fuct+95HTLcdwq0RgK5Iz
	 lSsu0hFGoicau84trJRRHIYubGhANzW+wKee32pMvpdmDLHzDYkAv+Y+RDzUir64io
	 phFuvBt5hilAeyamBQdkPJtFH3lrISngr5HW4k0UvMVP3HH3PL1ngrc6X66Vnf4wu6
	 OIFJJXbthFCqR6CzeLnrWA1f90gLOeQTTF8hFzd8U/xnGyYmPicXDtHsxEyFNM3Xca
	 hXGpkJf0v9gPA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:55 +0000
Subject: [PATCH v2 12/13] ptp: vmclock: convert mmap hook to mmap_prepare
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
Message-Id: <20261124-late-2026-mmap_prepare-v2-12-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org, David Woodhouse <dwmw@amazon.co.uk>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2115; i=ljs@kernel.org;
 h=from:subject:message-id; bh=cW06dufDxxurFECoGUtsKanmgN5mVh9JU1n9DwUlF+c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ0rUB1lesPbqmbJgNvPOB1avtaw+P/x3Y3Hccft6P
 pYlE/YpdpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiJ7cx/FO8oGkyMUCeZdmO
 yW/19f9I/BF48NiouMQ8yLmwfZrEbkeGX8xe9be/bRf592j1j6f9U3c+nsYq1X3k/u9VLzZ8avR
 lb+cGAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
I/O PFN remap mmap action to map the clock page and retaining the -EAGAIN
error on failure via the action error override.

Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/ptp/ptp_vmclock.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ptp/ptp_vmclock.c b/drivers/ptp/ptp_vmclock.c
index 7f25fe6c2ce2..6a1d5f40a566 100644
--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -364,27 +364,26 @@ struct vmclock_file_state {
 	atomic_t seq;
 };
 
-static int vmclock_miscdev_mmap(struct file *fp, struct vm_area_struct *vma)
+static int vmclock_miscdev_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct vmclock_file_state *fst = fp->private_data;
+	struct vmclock_file_state *fst = desc->file->private_data;
 	struct vmclock_state *st = fst->st;
 
-	if ((vma->vm_flags & (VM_READ|VM_WRITE)) != VM_READ)
+	if (!vma_desc_test(desc, VMA_READ_BIT) ||
+	    vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EROFS;
 
 	/*
 	 * Restrict the read-only mapping so it cannot be upgraded to
 	 * writable later with mprotect().
 	 */
-	vm_flags_clear(vma, VM_MAYWRITE);
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
 
-	if (vma->vm_end - vma->vm_start != PAGE_SIZE || vma->vm_pgoff)
+	if (vma_desc_size(desc) != PAGE_SIZE || desc->pgoff)
 		return -EINVAL;
 
-	if (io_remap_pfn_range(vma, vma->vm_start,
-			       st->res.start >> PAGE_SHIFT, PAGE_SIZE,
-			       vma->vm_page_prot))
-		return -EAGAIN;
+	mmap_action_ioremap_full(desc, st->res.start >> PAGE_SHIFT);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -484,7 +483,7 @@ static const struct file_operations vmclock_miscdev_fops = {
 	.owner = THIS_MODULE,
 	.open = vmclock_miscdev_open,
 	.release = vmclock_miscdev_release,
-	.mmap = vmclock_miscdev_mmap,
+	.mmap_prepare = vmclock_miscdev_mmap_prepare,
 	.read = vmclock_miscdev_read,
 	.poll = vmclock_miscdev_poll,
 };

-- 
2.56.1

