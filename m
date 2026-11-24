Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529177;
	b=qZf8RbwWMOEWO5ueFON7KiBMx0YxDpoiH32hc14LzUnq897vlztlEcnYDYlPIJslyJ28
	 65pLwfY8wET6mKpDuJeh4GLtFBkmw97kaLx0YHCuLzU1JG5QlWkUwLWBjb3wh6jfV7+UB
	 T3oV83L6q9U38WpGmBZ6izizfrVZJg2SMIHTcp4Y7LlZBEoLQfYq+tn9y7y+UEjuLVdrr
	 lfnjts+hqcM33usaFL7bMHiSs9ij8tIE027i+swI58/5uhq4an2zn/Pnk5FSthWhgMC0L
	 kzgtwPqa+9h9zIEudyf+OxedvjiPXuh6Jzu8vv8X1R6v4g3MPZUCrbOES4H74r4Krkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529177;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=7FUmabyr4uQL+774Pvtn0Hclc0nu9L2r9AtaFETc/GA=;
	b=5AS3zPxkaznlCfH2CAmEA+DgofauWmx7CAE2922pENInz1utzvNaa91nPD8IoF0GRqMh
	 KI/r/llgK11X5Y2uTjBgH/LRZwscWz7OrPU7Yk1RhppIBE2zDd4Ox5FpS2ICJOvdtsWQ8
	 +33WC5+8G7y9lDOAEeCm1dTYkV1KxNGRl4+K6UI89qVaCyG2rpOuUBL4+AlYq9sYrQWs3
	 lRhM5VY26Qx+VELW0iksHccpAPosigYxBsdbm/etY9A43vpEimxBVEufoHqG/xf2f6x+k
	 7byaazbPgIuIlq939nopUY+KBbhBtq0vMzX8oALnZ0jJORhQg0FWyJ3JgNTi8ERtz1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNip109e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97FD606A6B7;
	Tue, 24 Nov 2026 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNip109e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C24F1F000F0;
	Tue, 24 Nov 2026 14:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529177;
	bh=7FUmabyr4uQL+774Pvtn0Hclc0nu9L2r9AtaFETc/GA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PNip109e1v8AW41xU7g1LBDLiTkaFRP8f4lZPkWTaQTZjRjFkQGMj8SHSlPBNZ2hH
	 laeFtadOphJlM/Zu0+Ptde0v4sw3DIojGjlR2m3Qeu4CzKMRUAYso+tGP3tNzqdpUU
	 3sU6lzTKuQWYqrxkL5hORf1O/+Hd+Wm4c8OvqIXcRd+ed0pWiVLiUh9729Yx9jx6Fi
	 dgXnxqAfIA8dZQ6o3EwPJ+IUCAlYnXIx9hj5ELXrFUEkSnPqlONUQf1SpQ6qeJt9wO
	 D7Z8L5+AC0tRE+/U+WmavqRwYF54su3iDaH7Xb22dOtX1vDC/N8NGim9zMmqD/7g1W
	 xIohsVS5dOzsw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:54 +0000
Subject: [PATCH v2 11/13] misc: bcm-vk: convert mmap hook to mmap_prepare
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
Message-Id: <20261124-late-2026-mmap_prepare-v2-11-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2129; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dRLES62L0oNx/h8n7oOxCXbdn7WuTRK+ZkJqntS+Ejg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ0rUZakxBThbH2CZem92EdvkV4oicReY36/xvsBfp
 jlz6+lPHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjI0nBGho3CNY3Z605Z/zPu
 KRDaKl1vlbg8hjs3tHkrV62rTZVdHSPDdePvS9YekA+OrkzRyBNLVHkfcy3a4bNpv8ypohR7gQP
 sAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
I/O PFN remap mmap action to map the BAR.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/misc/bcm-vk/bcm_vk_dev.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/bcm-vk/bcm_vk_dev.c b/drivers/misc/bcm-vk/bcm_vk_dev.c
index 88ee3a417616..25a2b46ebad9 100644
--- a/drivers/misc/bcm-vk/bcm_vk_dev.c
+++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
@@ -1201,9 +1201,9 @@ static long bcm_vk_reset(struct bcm_vk *vk, struct vk_reset __user *arg)
 	return ret;
 }
 
-static int bcm_vk_mmap(struct file *file, struct vm_area_struct *vma)
+static int bcm_vk_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct bcm_vk_ctx *ctx = file->private_data;
+	struct bcm_vk_ctx *ctx = desc->file->private_data;
 	struct bcm_vk *vk = container_of(ctx->miscdev, struct bcm_vk, miscdev);
 	unsigned long pg_size;
 
@@ -1212,16 +1212,16 @@ static int bcm_vk_mmap(struct file *file, struct vm_area_struct *vma)
 
 	pg_size = ((pci_resource_len(vk->pdev, VK_MMAPABLE_BAR) - 1)
 		    >> PAGE_SHIFT) + 1;
-	if (vma->vm_pgoff + vma_pages(vma) > pg_size)
+	if (desc->pgoff + vma_desc_pages(desc) > pg_size)
 		return -EINVAL;
 
-	vma->vm_pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
-			  >> PAGE_SHIFT);
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	desc->pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
+			>> PAGE_SHIFT);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+
+	mmap_action_ioremap_full(desc, desc->pgoff);
 
-	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-				  vma->vm_end - vma->vm_start,
-				  vma->vm_page_prot);
+	return 0;
 }
 
 static long bcm_vk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -1262,7 +1262,7 @@ static const struct file_operations bcm_vk_fops = {
 	.write = bcm_vk_write,
 	.poll = bcm_vk_poll,
 	.release = bcm_vk_release,
-	.mmap = bcm_vk_mmap,
+	.mmap_prepare = bcm_vk_mmap_prepare,
 	.unlocked_ioctl = bcm_vk_ioctl,
 };
 

-- 
2.56.1

