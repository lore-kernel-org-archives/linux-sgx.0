Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17D6C04AB6
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E04F27BEC
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfFCG2H convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:28:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:38124 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfFCG2H (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 02:28:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jun 2019 23:28:06 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga005.jf.intel.com with ESMTP; 02 Jun 2019 23:28:05 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 2 Jun 2019 23:28:05 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.57]) with mapi id 14.03.0415.000;
 Sun, 2 Jun 2019 23:28:05 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
Thread-Topic: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
Thread-Index: AQHVGAkjeU1nLGbLQ0COV0gRY1rFBqaJcW8w
Date:   Mon, 3 Jun 2019 06:28:04 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ECC11@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-9-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-9-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDY1NDk3MjItY2ViNC00NTU1LTk0YmEtZGY0ZWZjYmUyMWNiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTVwvRWlaemdWMVwvY0JVb1hhODlWSVdyV0tXb1daNHI3UkhnaUx1VkFcL05LNVBQQUJmSTQyZHk1WEd6bjdITW9kMSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Friday, May 31, 2019 4:32 PM
> 
> diff --git a/include/linux/security.h b/include/linux/security.h index
> 659071c2e57c..2f7925eeef7e 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -392,6 +392,8 @@ void security_inode_invalidate_secctx(struct inode *inode);  int
> security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);  int
> security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);  int
> security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
> +int security_enclave_load(struct vm_area_struct *vma, unsigned long prot,
> +			  unsigned long *allowed_prot);

Per my comments to the cover letter, security_enclave_load() should have a signature similar to the following:

int security_enclave_load(struct file *enclave_fd, unsigned long linear_address, unsigned long nr_pages, int prot, struct vm_area_struct *source_vma);

@enclave_fd identifies the enclave to which new pages are being added.
@linear_address/@nr_pages specifies the linear range of pages being added.
@prot specifies the initial protection of those newly added pages. It is taken from the vma covering the target range.
@source_vma covers the source pages in the case of EADD. An LSM is expected to make sure security_file_mprotect(source_vma, prot, prot) would succeed before checking anything else, unless @source_vma is NULL, indicating pages are being EAUG'ed. In all cases, LSM is expected to "remember" @prot for all those pages to be checked in future security_file_mprotect() invocations.

>  #else /* CONFIG_SECURITY */
