Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793912811;
	b=CY/R6G9SVKsK7qEE744fCoJ8Xq0oM+vjY4xNZhrX9DeMUzXGj3h1KWMsNRnrULOaxgeN
	 XaxjHyCkTHTmY7od9lGivAdMgFCM34J2a4ArO9VvIHqRcfS4k3ULvs5f7GXc/ybL3UqTr
	 0f8d/Ns1pvuCDpUuyiz1xdh1NWMBg7GGNNwMSMVDzwLcJ6VKwfTfBOxcS8CLdRdb13ssV
	 P0wSjWQXSkligQazXPoClB4byCNYcWYAdAptEiYScWJf04kLZy4NOR822NwIam3bTlXDF
	 FFJpIYUkcfDKTc2hMcrM6KXzVxCpQICbpFzZiUfoUizrYYwlFakc8R2RWIosf55yfxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793912811;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=lMfCHuJWDITAzVX5MILlRUAfVtlxLQX6U8OJOyztS0Q=;
	b=Dt+Dls7yKOnhWGt/dV0AbWYHJ0Qhx+74xNJePRtvoLaO4q+G4l+WHLx23Ww895odhZQD
	 e5YXhZawFjRZv9ls0NY+cQeOEyV9VqAaCTtMzxgCyMTekWHmu2PpFbvy1zb+C1YMr2Ud4
	 sl2jok7IkSnUlGdodNA3G9xCi8cg8vsFbqUOpJrw+XeaQbmGDCIEHaQCuhcvfA41U2WVW
	 VX+ZkzmWSpvF824SM5zGqzdt/jPtTwoFhb5RsfUJgtJ/OLIDZ6+uvWab+rhSHEpp3OWGp
	 Cf4mAw/OyvbxGc9BV96Iyj0Xu+uaWMRLGGpywce2ob3RGIOlIb7SZ+qQoQ1krU6rK+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyoADFGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C01606A33B;
	Thu,  5 Nov 2026 21:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyoADFGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70931F008A2;
	Thu,  5 Nov 2026 21:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912810;
	bh=lMfCHuJWDITAzVX5MILlRUAfVtlxLQX6U8OJOyztS0Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hyoADFGoZhaTWJkzXcW3KcbEavv04p8OShbOv92vBdUSDNLHC33p5UKp1V2NVcrld
	 kDlm4+Dh0N0ewg6c+CsYgrDJ3ZyQfeLnEMeGuWWhUOa1JWAqXOF3EIa9dU7hEYQurC
	 UD8uUTqIpkS8973AB0tlJQaOj0TVHyTL25qiKUL5PD3kHvTGhvyIEbBHKWXDn6uHka
	 RoxnfP2r7Ju1UsLJ3jtzSicq0aWOqHOlTJAt5o8ROmzR1tSO11ZVBsg+5OZeT4rkNp
	 9MHuwVurtm4FxobT/XptLLk7AHWfQIwdo04JpdFyuH/BI40j4CP1PTKjHXSsUS4XXm
	 oJDzW5rZ2ElnQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:05:35 +0000
Subject: [PATCH 04/14] vduse: convert IOVA domain mmap hook to mmap_prepare
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
Message-Id: <20261105-late-2026-mmap_prepare-v1-4-c56aadfbab8a@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1527; i=ljs@kernel.org;
 h=from:subject:message-id; bh=f+7KpJr4q75MSHX3Bd7fDuPR7a/rNIIIf/bMN+NEgYc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevF8du8y356wo75UohnvW1WmG2azZxoEG9l+mvHw8c
 ZHxmh0fOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRiBOMDB0R1y2sCsxZCz9d
 WmjgP+cKZ4HBz+NXpWMcv1wV1woTUGNk+FWtznBzgiPz5WrBrQefRpSzaacb3N2dE78n6eYhful
 ubgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
only sets VMA flags, operations and private data.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/vdpa/vdpa_user/iova_domain.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_user/iova_domain.c
index b6c958224b7c..64465f690a4d 100644
--- a/drivers/vdpa/vdpa_user/iova_domain.c
+++ b/drivers/vdpa/vdpa_user/iova_domain.c
@@ -575,13 +575,13 @@ static const struct vm_operations_struct vduse_domain_mmap_ops = {
 	.fault = vduse_domain_mmap_fault,
 };
 
-static int vduse_domain_mmap(struct file *file, struct vm_area_struct *vma)
+static int vduse_domain_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct vduse_iova_domain *domain = file->private_data;
+	struct vduse_iova_domain *domain = desc->file->private_data;
 
-	vm_flags_set(vma, VM_DONTDUMP | VM_DONTEXPAND);
-	vma->vm_private_data = domain;
-	vma->vm_ops = &vduse_domain_mmap_ops;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT, VMA_DONTEXPAND_BIT);
+	desc->private_data = domain;
+	desc->vm_ops = &vduse_domain_mmap_ops;
 
 	return 0;
 }
@@ -606,7 +606,7 @@ static int vduse_domain_release(struct inode *inode, struct file *file)
 
 static const struct file_operations vduse_domain_fops = {
 	.owner = THIS_MODULE,
-	.mmap = vduse_domain_mmap,
+	.mmap_prepare = vduse_domain_mmap_prepare,
 	.release = vduse_domain_release,
 };
 

-- 
2.56.0

