Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05D7C2D0E2
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 16:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6C923741
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 16:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgIXQ1z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 12:27:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:10938 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728583AbgIXQ1z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 12:27:55 -0400
IronPort-SDR: JURWzQJ7P/rI5MiDzfuo+ivCO8x3XISUlfAuNDavcwifCFcnBjcUiuvYSYjnrRrSUB1Z0PxfFp
 Iap7IaKSlo0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149009660"
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="149009660"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 09:27:53 -0700
IronPort-SDR: hFXbLew9Cyi6uK+36ft0QonUw+RdzAvcY53J0lCSlyH2xqXN+pWnDrUc6amf9IBeDFUbDbHa1B
 pgFFT8hNru5g==
X-IronPort-AV: E=Sophos;i="5.77,298,1596524400"; 
   d="scan'208";a="347892032"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 09:27:52 -0700
Date:   Thu, 24 Sep 2020 09:27:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200924162750.GC22819@linux.intel.com>
References: <20200918235337.GA21189@sjchrist-ice>
 <1B23E216-0229-4BDD-8B09-807256A54AF5@amacapital.net>
 <20200922125801.GA133710@linux.intel.com>
 <25d46fdc-1c19-2de8-2ce8-1033a0027ecf@intel.com>
 <20200923143305.GE5160@linux.intel.com>
 <982367fb-17b7-a647-a33b-8c8e5e1511a2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <982367fb-17b7-a647-a33b-8c8e5e1511a2@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 07:50:15AM -0700, Dave Hansen wrote:
> On 9/23/20 7:33 AM, Jarkko Sakkinen wrote:
> > The consequence is that enclaves are best created with an ioctl API and the
> > access control can be based only to the origin of the source file for the
> > enclave data, i.e. on VMA file pointer and page permissions. For example,
> > this could be done with LSM hooks that are triggered in the appropriate
> > ioctl's and they could make the access control decision based on this
> > information.
> > 
> > Unfortunately, there is ENCLS[EMODPE] that a running enclave can use to
> > upgrade its permissions. If we do not limit mmap() and mprotect(), enclave
> > could upgrade its permissions by using EMODPE followed by an appropriate
> > mprotect() call. This would be completely hidden from the kernel.
> > 
> > Add 'mprotect' hook to vm_ops, so that a callback can be implemeted for SGX
> > that will ensure that {mmap, mprotect}() permissions do not surpass any of
> > the original page permissions. This feature allows to maintain and refine
> > sane access control for enclaves.
> 
> Maybe I'm just being dense, but I still don't have a clear idea what
> function this hook serves.
> 
> I understand that SGX has an orthogonal set of page permissions to the
> normal x86 page tables.  It needs these so that the OS can't play nasty
> tricks on the enclave, like removing read-only protections that provide
> hardening.
> 
> But, I still don't get the connection to mprotect() and the x86 paging
> permissions.  If the enclave's permissions are orthogonal, then why
> bother with this hook?  Why does the OS view of the enclave's memory matter?

For the purpose of this discussion, ignore the enclave permissions.  The only
reason they're mentioned is to explain the background (well, try to) of how we
ended up at an ->mprotect() hook.  There was a great deal of discussion in the
past about whether or not we could use enclave permissions to enforce OS
permissions.  The TL:DR version is that because of ENCLU[EMODPE], the answer
is "no".

What we're preventing via ->mprotect() is using SGX to bypass existing
restrictions on code execution, e.g. noexec and LSM policies.

Because code must first be loaded into an enclave before it can be executed,
all enclaves are kind of a variant on (in SELinux terminology) either EXECMOD
or EXECMEM.  I.e. it's simply not possible to execute an enclave by mapping
the source file as executable.  This effectively allows userspace to bypass a
noexec FS by loading code into an enclave without EXEC perms on the source
file, only on /dev/sgx/enclave, and denying EXEC on /dev/sgx/enclave would
prevent running _any_ enclave.

The ->mprotect() hook is used by SGX to require userspace to declare what
permissions are allowed on any given enclave page, e.g. SGX's mmap()/mprotect()
requires all underlying enclave pages to be declared as executable if the
mmap()/mprotect() is specifying VM_EXEC.  By requiring userspace to declare
their intent up front, SGX can then enforce noexec by requiring pages that are
declared as executable to have VM_MAYEXEC set in the source VMA when loading
code into the enclave.

As Jarkko pointed out, an alternative to adding ->mprotect() would be to
simply require VM_MAYEXEC on _all_ source VMAs when loading code into the
enclave.  That would work, albeit with the potentially undesirable side effect
of preventing loading any part of an enclave from e.g. a noexec, readonly FS.

But, unconditionally requiring VM_MAYEXEC doesn't address the Linux Security
Module hooks for mmap() and mprotect(), which could also be bypassed by abusing
SGX.  E.g. a process could gain arbitrary code execution by loading code from
anonymous memory into an enclave, as the LSM checks hooks at mmap()/mprotect()
will see always vm_file=/dev/sgx/enclave.  An LSM could deny a process access
to /dev/sgx/enclave, but again that is very coarse granularity.

By requiring userspace to declare permissions up front (when loading code/data
into an enclave), SGX can make explicit upcalls to LSMs hooks at load time so
that an LSM can enforce a meaningful policy, e.g. require all enclave code to
originate from an executable file system.  This series doesn't actually
implement the LSM integration, but it does ensure that _if_ we want to add LSM
support in the future, we can do so without breaking userspace.
