Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F06FC46470
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 17:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2152F25E4F
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 17:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfE3RVx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 13:21:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:15132 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbfE3RVw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 May 2019 13:21:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 10:21:51 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 30 May 2019 10:21:51 -0700
Date:   Thu, 30 May 2019 10:21:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
        David Rientjes <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190530172150.GA23930@linux.intel.com>
References: <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
 <20190524224107.GJ365@linux.intel.com>
 <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
 <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com>
 <CALCETrWTXCb1jru1G5G3sOp5AV8iYUtrffiSxE-5gotXtrZD-g@mail.gmail.com>
 <20190528214107.GD13158@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EB439@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654EB439@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 29, 2019 at 10:38:06PM -0700, Xing, Cedric wrote:
> > From: Christopherson, Sean J
> > Sent: Tuesday, May 28, 2019 2:41 PM
> > 
> > On Tue, May 28, 2019 at 01:48:02PM -0700, Andy Lutomirski wrote:
> > > On Tue, May 28, 2019 at 1:24 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > Actually, I think we do have everything we need from an LSM perspective.
> > > > LSMs just need to understand that sgx_enclave_load() with a NULL vma
> > > > implies a transition from RW.  For example, SELinux would interpret
> > > > sgx_enclave_load(NULL, RX) as requiring FILE__EXECMOD.
> > >
> > > You lost me here.  What operation triggers this callback?  And
> > > wouldn't sgx_enclave_load(NULL, RX) sometimes be a transition from RO
> > > or just some fresh executable zero bytes?
> > 
> > An explicit ioctl() after EACCEPTCOPY to update the allowed permissions.
> > For all intents and purposes, the EAUG'd page must start RW.  Maybe a better way to phrase
> > it is that at some point the page must be writable to have any value whatsover.
> > EACCEPTCOPY explicitly requires the page to be at least RW.  EACCEPT technically doesn't
> > require RW, but a RO or RX zero page is useless.  Userspace could still EACCEPT with RO or
> > RX, but SGX would assume a minimum of RW for the purposes of the LSM check.
> 
> Why is an explicit ioctl() necessary after EACCEPTCOPY? Or why is mprotect() not sufficient?

Ignore this, I was trying to avoid having to add a vm_ops mprotect(),
which Andy pointed out was silly.

> > In theory, it's still your MAXPERM model, but with the unnecessary states removed and the
> > others enforced/handled by the natural SGX transitions instead of explictly in ioctls.
> > Underneath the hood the SGX driver would still need to track the MAXPERM.
> 
> What are the "unnecessary states" removed? 

Andy proposed taking full RWX in MAXPERMs, but really we only need "can
writes ever happen to this page", as that allows the SGX driver to avoid
having to track if a page has been mapped PROT_WRITE by any VMA in any
process.

> I'm not sure understand the proposal fully. The whole thing looks to me like
> the driver is undertaking things that should/would otherwise be done by
> mmap()/mprotect() syscalls. It also imposes unnecessary restrictions on user
> mode code, such as mmap(PROT_NONE), ACTIVATE_REGION can be called only once,
> etc. What'd happen if ACTIVATE_REGION is called with a range spanning
> multiple/partial VMAs? What'd happen if an enclave was unmapped than mapped
> again? I'd say the proposal is unintuitive at least.
> 
> In theory, if the driver can keep track of MAXPERM for all pages within an
> enclave, then it could fail mmap() if the requested prot conflicts with any
> page's MAXPERM within that range. Otherwise, MAXPERM could be copied into
> VM_MAY* flags then mprotect() will just follow through. Wouldn't that be a
> much simpler and more intuitive approach?

Ignore all this, again I was trying to avoid hooking mprotect().
