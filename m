Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C830C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 16:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 210B52084B
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 16:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfFDQax (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 12:30:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:37305 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbfFDQaw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 12:30:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 09:30:51 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2019 09:30:50 -0700
Date:   Tue, 4 Jun 2019 09:30:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Message-ID: <20190604163050.GA32350@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
 <20190603171549.GE13384@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654ED042@ORSMSX116.amr.corp.intel.com>
 <10a49f97-b3be-ed09-2821-68157f01aebe@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10a49f97-b3be-ed09-2821-68157f01aebe@tycho.nsa.gov>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 04, 2019 at 11:33:44AM -0400, Stephen Smalley wrote:
> The RFC series seemed to dispense with the use of the sigstruct file and
> just used the source file throughout IIUC.  That allowed for reuse of
> FILE__* permissions without ambiguity rather than introducing separate
> ENCLAVE__* permissions or using /dev/sgx/enclave inode as the target of all
> checks.

Drat, I meant to explicitly call that out in the cover letter.  Yes, the
concept of using sigstruct as a proxy was dropped for this RFC.  The
primary motivation was to avoid having to take a hold a reference to the
sigstruct file for the lifetime of the enclave, and in general so that
userspace isn't forced to put sigstruct into a file.

> Regardless, IIUC, your approach requires that we always check FILE__EXECMOD,
> and FILE__EXECUTE up front during security_enclave_load() irrespective of
> prot so that we can save the result in the f_security for later use by the
> mprotect hook.

Correct, this approach requires up front checks.

> This may generate many spurious audit messages for cases
> where PROT_EXEC will never be requested, and users will be prone to just
> always allowing it since they cannot tell when it was actually needed.

Userspace will be able to understand when PROT_EXEC is actually needed
as mprotect() will (eventually) fail.  Of course that assumes userspace
is being intelligent and isn't blindly declaring permissions they don't
need, e.g. declaring RWX on all pages even though the enclave never
actually maps a RWX or RW->RX page.

One thought for handling this in a more user friendly fashion would be
to immediately return -EACCES instead of modifying @allowed_prot.  An
enclave that truly needs the permission would fail immediately.

An enclave loader that wants/needs to speculatively declare PROT_EXEC,
e.g. because the exact requirements of the enclave are unknown, could
handle -EACCESS gracefully by retrying the SGX ioctl() with different
@allowed_prot, e.g.:

  region.flags = SGX_ALLOW_READ | SGX_ALLOW_WRITE | SGX_ALLOW_EXEC;

  ret = ioctl(fd, SGX_IOC_ENCLAVE_ADD_REGION, &region);
  if (ret && errno == EACCES && !(prot & PROT_EXEC)) {
      region.flags &= ~SGX_ALLOW_EXEC;
      ret = ioctl(fd, SGX_IOC_ENCLAVE_ADD_REGION, &region);
  }

This type of enclave loader would still generate spurious audit messages,
but the spurious messages would be limited to enclave loaders that are
deliberately probing the allowed permissions.

> >The noexec case should be addressed in IOC_ADD_PAGES by testing
> >@source_vma->vm_flags & VM_MAYEXEC.
> >
> >>
> >>>* In hook security_file_free(), if @file is an  enclave, free storage
> >>>   allocated for WRITTEN flags.
> 
