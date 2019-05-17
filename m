Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA76C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C5C22087B
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfEQSV0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 14:21:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:19131 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbfEQSV0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 May 2019 14:21:26 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 11:21:25 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 May 2019 11:21:24 -0700
Date:   Fri, 17 May 2019 11:21:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
Message-ID: <20190517182124.GF15006@linux.intel.com>
References: <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <20190517172953.GC15006@linux.intel.com>
 <DFE03E0C-694A-4289-B416-29CDC2644F94@amacapital.net>
 <20190517175500.GE15006@linux.intel.com>
 <CAHk-=wgH2FBzBG3_RZSuatpYCj8DCQZipJYp9vh3Wy_S3Qt4-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgH2FBzBG3_RZSuatpYCj8DCQZipJYp9vh3Wy_S3Qt4-g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 17, 2019 at 11:04:22AM -0700, Linus Torvalds wrote:
> On Fri, May 17, 2019 at 10:55 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > In this snippet, IS_PRIVATE() is true for anon inodes, false for
> > /dev/sgx/enclave.  Because EPC memory is always shared, SELinux will never
> > check PROCESS__EXECMEM for mprotect() on/dev/sgx/enclave.
> 
> Why _does_ the memory have to be shared? Shared mmap() is
> fundamentally less secure than private mmap, since by definition it
> means "oh, somebody else has access to it too and might modify it
> under us".
> 
> Why does the SGX logic care about things like that? Normal executables
> are just private mappings of an underlying file, I'm not sure why the
> SGX interface has to have that shared thing, and why the interface has
> to have a device node in the first place when  you have system calls
> for setup anyway.
> 
> So why don't the system calls just work on perfectly normal anonymous
> mmap's? Why a device node, and why must it be shared to begin with?

I agree that conceptually EPC is private memory, but because EPC is
managed as a separate memory pool, SGX tags it VM_PFNMAP and manually
inserts PFNs, i.e. EPC effectively it gets classified as IO memory. 

And vmf_insert_pfn_prot() doesn't like writable private IO mappings:

   BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
