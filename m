Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795529050;
	b=EiFeFhaz60e4VEhGJL2vvLe8P0TlzLdTuoG4kT/RslzdORkduj2W/DqaF2/ODZeM/Xw0
	 yM3hW2q32VyVi3eHL+hBWMKni7aS3fuBoXvRQmjsG3SUENjE8IiSxJPobqSpuSlJvvzYL
	 gyC9ritZwO8hlpDHdPa8pPq5mpP9y8OSW4tylz7gcv4fUEOm9a4dWqmNj/HSpItEV37Jz
	 IimLmUI/+l8UDDAunZMmhGE8KpcY/PHNGSt9mvT4dwmKJ+sHMRRTxTqTtvdtNbQ8K/Ku6
	 VfQbpssdB38zS86LpLxmCF5bi3D7KHxdkdT16Iceu6d8igNdPG+T5wILL9u/TbZ9DMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529050;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Q5EZNv1hoZNsO5LavIHZOtKGm9yaPJJ0vpR/2Fm0XAo=;
	b=4SSi2kdJ7NadZXkFhzzO0ZoUf/RfBFR8Pt/Ia0x8K0K04aUMJ9dfSccMJVL6UNt2fSvD
	 fwDXntZH9MCx1mF2KcmnsxxERBg/JIpos/lDCms2z5WHpjQrVPSx7I878zOfpkFWiJPS7
	 OZ6MIdoNmA33OGkamhzh24a4Lx/pQQdzbMG3S+0iBPkFf0ABiZQX61uhhIMwL1HLj6OPu
	 MOZLLWLIkVvCiQ0AdS7b+EraQEtZHMo8D7FN6c7ApV0m3GFPeaKwJ4dS6Il+oSn19M30e
	 Wj45hAAOB9J/w5Pv1Q7iAWVuLWx82p/M//yLoJue2hEIc9eVltAARtGBjlfOEcmjYlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oCh0V0So;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED58606A688;
	Tue, 24 Nov 2026 14:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oCh0V0So
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2399E1F0089E;
	Tue, 24 Nov 2026 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795529049;
	bh=Q5EZNv1hoZNsO5LavIHZOtKGm9yaPJJ0vpR/2Fm0XAo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oCh0V0SotsrCn9TWTvx54DUqWZ9E5lDYqEYTa/SkfK/tDZ1vzOW7K1B+iPFhd+J9N
	 IMBPfgrvCJBhLO25ivWueHZaBO3todJlUJ0FWSSUg0jzV/v3Kdf01vHxWwiC8NT3KE
	 ajXML1m9831Htpg68RVCN87q2izRhoN9KwgCRK21KifWLU8cP4xS+xyd/1jjXEispa
	 aqVYHhHGm2uNElvmmoTqoOj7YxZlaQQwUJHKVMrL0iBjaGly4K77/on649tqcw+0IA
	 JY8UEIMdEo+PH7RuljHaB/bfBS1rItq08+6Dk419a5HID7kx4JwCgJhAo1hyslk2fg
	 PozyX57TBWNCQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 14:02:46 +0000
Subject: [PATCH v2 03/13] mshv_vtl: convert mmap hooks to mmap_prepare
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
Message-Id: <20261124-late-2026-mmap_prepare-v2-3-0b0d99d655f9@kernel.org>
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
 linux-mm@kvack.org, Kameron Carr <kameroncarr@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2186; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JYQK3wK0K9TDfgdH5JvWWtvXfv1ER9V1zmvapkfLQMQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZZ4o1PGpWtp6mWtz06svzJY2dja9sXqWeFlqRVDKj9
 f9fwfsiHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjICl9Ghr1n6kyr2U7mXtq1
 vXBDo9yCMwtuvVqu9PjO+TrncsbFO5cz/Hd3+BZswOIzW06xUO7ljlVNq98b5kUcm9Fu0HT10/m
 DSowA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Move from the deprecated mmap hook to the new mmap_prepare hook for both
the mshv_vtl and mshv_vtl_low devices. These only set VMA operations and
flags.

Tested-by: Kameron Carr <kameroncarr@linux.microsoft.com>
Reviewed-by: Kameron Carr <kameroncarr@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/hv/mshv_vtl_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index 2d4fe24cecbf..9bfe808f71ed 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -873,9 +873,9 @@ static const struct vm_operations_struct mshv_vtl_vm_ops = {
 	.fault = mshv_vtl_fault,
 };
 
-static int mshv_vtl_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mshv_vtl_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &mshv_vtl_vm_ops;
+	desc->vm_ops = &mshv_vtl_vm_ops;
 
 	return 0;
 }
@@ -893,7 +893,7 @@ static const struct file_operations mshv_vtl_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = mshv_vtl_ioctl,
 	.release = mshv_vtl_release,
-	.mmap = mshv_vtl_mmap,
+	.mmap_prepare = mshv_vtl_mmap_prepare,
 };
 
 static void mshv_vtl_synic_mask_vmbus_sint(void *info)
@@ -1324,10 +1324,10 @@ static const struct vm_operations_struct mshv_vtl_low_vm_ops = {
 	.huge_fault = mshv_vtl_low_huge_fault,
 };
 
-static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
+static int mshv_vtl_low_mmap_prepare(struct vm_area_desc *desc)
 {
-	vma->vm_ops = &mshv_vtl_low_vm_ops;
-	vm_flags_set(vma, VM_HUGEPAGE | VM_MIXEDMAP);
+	desc->vm_ops = &mshv_vtl_low_vm_ops;
+	vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT, VMA_MIXEDMAP_BIT);
 
 	return 0;
 }
@@ -1335,7 +1335,7 @@ static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
 static const struct file_operations mshv_vtl_low_file_ops = {
 	.owner		= THIS_MODULE,
 	.open		= mshv_vtl_low_open,
-	.mmap		= mshv_vtl_low_mmap,
+	.mmap_prepare	= mshv_vtl_low_mmap_prepare,
 };
 
 static struct miscdevice mshv_vtl_low = {

-- 
2.56.1

