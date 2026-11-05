Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912921;
	b=k5dtIvGHixjdhfuHdGxOdiCl+kkxDfwCSiFrFt/pgqCpihI62H9D5BZZNBN+6hcooWrm
	 PXwBrI5n7GN4TLPyczrPI7n/EHeWSReqZvKitf0TMyhg0q85IRdUF6XO8CqKFCx0FcOZ5
	 ViUD9f6ZD5wJ5pF5yPYkdiFqMpZoPEXFATl9MZYXAS7vlAksIMaLSZrPBgdYx981KJkPR
	 RkP0XqbCApCgpLNcSR+/LMiOUT2wTdYzLiOItbqi5wX5QudNJwPjlCux/IsU1aCzGriQT
	 LvqEvaDrHdDlAfNO6lyxXJm6Gcws6FoW15Nx1Vc7rckr4gvkD6f7mA1AaMBuckieCZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912921;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=jwg42VGqWUt+sFFBng+mWbW24dAsrwHOUVsOhHWbSTw=;
	b=qZfw3f3Ni6KfTnJp4X+AlCrm13GPKG3lwUuUAS51sZJj1IMS9oD/SKluukTzSMhod0Ps
	 PyOoNb5144y4rZyvtPlJOuu72Sz3739kc10owFymNkCbjRrwt1PiX2idieVWWO79n0J4K
	 8flSetaqo3eDYwHTLQxX+QUIm/2LyyWKPZkaywtv8TIra6kTTb4NCV+6nXxiLEXn4k9n3
	 RqVdBcCBjYvafDX4wZOtJKSV3DlO4nk9gWns+R87as5QnCTq73UnGyJtu3YS0zMitStEt
	 qj51r7pbAtxJDj1fpO3uwadTQ47nL5C08w0UE5gVgizKhEv+/TgXIaGkK9hzmn30qEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWUcIhBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9EC606A333;
	Thu,  5 Nov 2026 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWUcIhBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4791F0089F;
	Thu,  5 Nov 2026 21:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912920;
	bh=jwg42VGqWUt+sFFBng+mWbW24dAsrwHOUVsOhHWbSTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QWUcIhBCGRma05CYBvlYAlcfi/meLWyeZtyVRMCsgC3eidcnSypogMH20WwSI92Vo
	 nUGOi0jOdOYQqRYbLuOn/e0wcApgbleVdCLsQVo3EKEbJwqtnb3wGYHGhtB20rZjFf
	 9cjWxmaAFDIk2PBAlcaRnTwCrwWQltxESQCDifUxijmFVrqzmV2MXoVZMTDDrJXm3G
	 3PjQF3mPdpLpyAUsd37oELANXqbeLiCVaA1MHfyYV/F300h88r1ZwlODccLQGzTUET
	 2T2/8rqNR+g7IR+53ri5dnAH76IBDmer8fSCNE/o5xkxllHyUDCt6gi9PZAsjUiLhR
	 fpGgLWaXY4uuQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:44 +0000
Subject: [PATCH 13/14] ptp: vmclock: convert mmap hook to mmap_prepare
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-13-c56aadfbab8a@kernel.org>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
To: Juergen Gross <jgross@suse.com>, 
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
 op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2068; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BtWkGlsdqRPyaFO3thb1+okxq61by8V/MZsK3ybf8bQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF8b8Ux/Tdcunl1xE7s19f5O+zJ7caTksSU+544kX
 NlyL3Eyb0cpC4MYF4OsmCLL8y/i+4NEwuZ1XvB3g5nDygQyhIGLUwAmkviF4X/5tD9fZqudmJGc
 eDXc+YjW+oBjJk1fYudKmvfOKpRJm3mE4a+0h0vYimsND/h+/73g4/Cy0C26a9UBpbxFppN2bn7
 cZ80GAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
I/O PFN remap mmap action to map the clock page and retaining the -EAGAIN
error on failure via the action error override.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/ptp/ptp_vmclock.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/ptp/ptp_vmclock.c b/drivers/ptp/ptp_vmclock.c
index bb0e14bac9f2..e44433430044 100644
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
2.56.0

