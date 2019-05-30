Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B458DC28CC0
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 22:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93B5526265
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 22:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfE3WDg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 18:03:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:42231 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfE3WDf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 May 2019 18:03:35 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 14:36:02 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 30 May 2019 14:36:01 -0700
Date:   Thu, 30 May 2019 14:36:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>,
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
Message-ID: <20190530213601.GC27551@linux.intel.com>
References: <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
 <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov>
 <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
 <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov>
 <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
 <20190530180110.GB23930@linux.intel.com>
 <CALCETrX2PgUc_jetXHqp85aaS0a0jHB8E7=T1rsW+5vyRgwnUA@mail.gmail.com>
 <20190530211645.GB27551@linux.intel.com>
 <CALCETrVAoDppmdJzkpwagt3q64M-QpNajXbKGR1yQdqyofeANQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVAoDppmdJzkpwagt3q64M-QpNajXbKGR1yQdqyofeANQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 30, 2019 at 02:23:07PM -0700, Andy Lutomirski wrote:
> On Thu, May 30, 2019 at 2:16 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, May 30, 2019 at 12:20:45PM -0700, Andy Lutomirski wrote:
> > > On Thu, May 30, 2019 at 11:01 AM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > On Thu, May 30, 2019 at 09:14:10AM -0700, Andy Lutomirski wrote:
> > > > > Enclave file -- that is, the file backing the vma from which the data is loaded.
> > > >
> > > > It wasn't explicitly called out in Andy's proposal(s), but the idea is
> > > > that the SGX driver would effectively inherit permissions from the source
> > > > VMA (EADD needs a source for the initial value of the encave page).
> > >
> > > I actually meant for it to *not* work like this.  I don't want the
> > > source VMA to have to be VM_EXEC.  I think the LSM should just check
> > > permissions on ->vm_file.
> >
> > But if ->vm_file is NULL, i.e. the enclave is not backed by a file,
> > then PROCESS__EXECMEM is required (or more likely, ENCLAVE__EXECMEM).
> >
> 
> If ->vm_file is NULL, then I think some privilege is needed.  I
> suppose the policy could have a new lesser permission EXECUNTRUSTED
> which is like EXECMOD but you can't modify it.  I'm not convinced this
> is particular important.

Assuming MRENCLAVE generated by Graphene or any other hosting scheme are
stable[1], then avoiding EXEC<whatever> means the user can effectively
whitelist what enclaves are runnable by Graphene, even if the kernel
doesn't implement security_enclave_create/init().

I agree that it probably isn't all that important, it's more of a "why
not" argument, i.e. what is gained by not using sigstruct as a proxy?

[1] What in the world is being attested if MRENCLAVE isn't stable?
