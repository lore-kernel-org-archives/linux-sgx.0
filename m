Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D94C28CC5
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:04:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45B9E2083E
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfFFCET (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 22:04:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:61296 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfFFCET (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 22:04:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 19:04:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,557,1549958400"; 
   d="scan'208";a="182148358"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2019 19:04:17 -0700
Date:   Wed, 5 Jun 2019 19:04:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
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
Subject: Re: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook
 for Intel SGX
Message-ID: <20190606020417.GL26328@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-9-sean.j.christopherson@intel.com>
 <CALCETrXf3ujAn6uOwWMU8SRZOvBRb8ALvo_LQvwxc899mrakwQ@mail.gmail.com>
 <20190604203649.GC7775@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EDB7D@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654EDB7D@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jun 04, 2019 at 02:43:09PM -0700, Xing, Cedric wrote:
> > From: Christopherson, Sean J
> > Sent: Tuesday, June 04, 2019 1:37 PM
> > 
> > On Tue, Jun 04, 2019 at 01:29:10PM -0700, Andy Lutomirski wrote:
> > > On Fri, May 31, 2019 at 4:32 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >  static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long
> > > > addr, diff --git a/include/linux/lsm_hooks.h
> > > > b/include/linux/lsm_hooks.h index 47f58cfb6a19..0562775424a0 100644
> > > > --- a/include/linux/lsm_hooks.h
> > > > +++ b/include/linux/lsm_hooks.h
> > > > @@ -1446,6 +1446,14 @@
> > > >   * @bpf_prog_free_security:
> > > >   *     Clean up the security information stored inside bpf prog.
> > > >   *
> > > > + * Security hooks for Intel SGX enclaves.
> > > > + *
> > > > + * @enclave_load:
> > > > + *     On success, returns 0 and optionally adjusts @allowed_prot
> > > > + *     @vma: the source memory region of the enclave page being
> > loaded.
> > > > + *     @prot: the initial protection of the enclave page.
> > >
> > > What do you mean "initial"?  The page is always mapped PROT_NONE when
> > > this is called, right?  I feel like I must be missing something here.
> > 
> > Initial protection in the EPCM.  Yet another reason to ignore SECINFO.
> 
> I know you guys are talking in the background that all pages are mmap()'ed
> PROT_NONE. But that's an unnecessary limitation.

Not all pages have to be mmap()'d PROT_NONE, only pages that do not have
an associated enclave page.

> And @prot here should be @target_vma->vm_flags&(VM_READ|VM_WRITE|VM_EXEC). 

I don't follow, there is no target_vma at this point.
