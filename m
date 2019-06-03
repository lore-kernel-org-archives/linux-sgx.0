Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E468DC04AB6
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C41EE27BEC
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 06:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbfFCG2z convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:28:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:29222 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfFCG2z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 02:28:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jun 2019 23:28:54 -0700
X-ExtLoop1: 1
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga005.jf.intel.com with ESMTP; 02 Jun 2019 23:28:54 -0700
Received: from orsmsx160.amr.corp.intel.com (10.22.226.43) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 2 Jun 2019 23:28:54 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX160.amr.corp.intel.com ([169.254.13.155]) with mapi id 14.03.0415.000;
 Sun, 2 Jun 2019 23:28:54 -0700
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
Subject: RE: [RFC PATCH 6/9] x86/sgx: Require userspace to provide allowed
 prots to ADD_PAGES
Thread-Topic: [RFC PATCH 6/9] x86/sgx: Require userspace to provide allowed
 prots to ADD_PAGES
Thread-Index: AQHVGAkiEcDZ+jyqSUy8jMAaVrxFBKaJZ0ng
Date:   Mon, 3 Jun 2019 06:28:53 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ECC35@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-7-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-7-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjUzM2MxNGEtZTU4NS00MzhlLWFkOGEtYmUyYjNlYjIzMWQyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiak0rSWg0Mk1hbDJlUHVIRDd0bXRUMWF4XC8xYnFEVzVTMEdvWUkzNnNGbEU4cUNZamlCWmMxd2gza3ZvOTluNzAifQ==
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
> ...to support (the equivalent) of existing Linux Security Module functionality.
> 
> Because SGX manually manages EPC memory, all enclave VMAs are backed by the same vm_file,
> i.e. /dev/sgx/enclave, so that SGX can implement the necessary hooks to move pages in/out
> of the EPC.  And because EPC pages for any given enclave are fundamentally shared between
> processes, i.e.
> CoW semantics are not possible with EPC pages, /dev/sgx/enclave must always be MAP_SHARED.
> Lastly, all real world enclaves will need read, write and execute permissions to EPC pages.
> As a result, SGX does not play nice with existing LSM behavior as it is impossible to
> apply policies to enclaves with any reasonable granularity, e.g. an LSM can deny access to
> EPC altogether, but can't deny potentially dangerous behavior such as mapping pages RW->RW
> or RWX.
> 
> To give LSMs enough information to implement their policies without having to resort to
> ugly things, e.g. holding a reference to the vm_file of each enclave page, require
> userspace to explicitly state the allowed protections for each page (region), i.e. take
> ALLOW_{READ,WRITE,EXEC} in the ADD_PAGES ioctl.
> 
> The ALLOW_* flags will be passed to LSMs so that they can make informed decisions when the
> enclave is being built, i.e. when the source vm_file is available.  For example, SELinux's
> EXECMOD permission can be required if an enclave is requesting both ALLOW_WRITE and
> ALLOW_EXEC.
> 
> Update the mmap()/mprotect() hooks to enforce the ALLOW_* protections, a la the standard
> VM_MAY{READ,WRITE,EXEC} flags.
> 
> The ALLOW_EXEC flag also has a second (important) use in that it can be used to prevent
> loading an enclave from a noexec file system, on
> SGX2 hardware (regardless of kernel support for SGX2), userspace could EADD from a noexec
> path using read-only permissions and later mprotect() and ENCLU[EMODPE] the page to gain
> execute permissions.  By requiring ALLOW_EXEC up front, SGX will be able to enforce noexec
> paths when building the enclave.

ALLOW_* flags shall be kept internal to LSM.

This patch is completely unnecessary.
