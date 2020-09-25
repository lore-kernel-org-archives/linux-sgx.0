Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E89BC4727E
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECF712087D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 22:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgIYWpH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 18:45:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:53529 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIYWpH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 18:45:07 -0400
IronPort-SDR: 8oNG5lL73a2zMqeLrCsFY6iKaE/OT1r/tyY4b6g4qcPuTl5MTds+L3QWJpuA4JAJQErvTJ8mSB
 P+5ukRk6gE0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9755"; a="159019383"
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="159019383"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 12:43:06 -0700
IronPort-SDR: 0cmbbxIOq+DRBwDZXU8oN+OtguZDJAfmZzzlqB5HURVs+a31qryQUHYiY8WcGsB/JaPgA3UctT
 bNXULHS8KJnA==
X-IronPort-AV: E=Sophos;i="5.77,303,1596524400"; 
   d="scan'208";a="291893055"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 12:43:05 -0700
Date:   Fri, 25 Sep 2020 12:43:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-ID: <20200925194304.GE31528@linux.intel.com>
References: <20200924192853.GA18826@linux.intel.com>
 <c680f7bd-2d82-6477-707f-cd03aae4b4aa@intel.com>
 <20200924200156.GA19127@linux.intel.com>
 <e4bcb25f-581a-da93-502b-b8f73e28286a@intel.com>
 <20200924202549.GB19127@linux.intel.com>
 <e25bfeaa-afb4-3928-eb80-50d90815eabb@intel.com>
 <20200924230501.GA20095@linux.intel.com>
 <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com>
 <20200925000052.GA20333@linux.intel.com>
 <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 10:18:28AM -0700, Dave Hansen wrote:
> Thanks for the walkthrough.  The thing that clicked for me seeing those
> examples was how the earlier ioctl(ADD_PAGE) is "bound" to later
> enforcement actions at enclave PTE creation time.
> 
> On 9/24/20 5:00 PM, Sean Christopherson wrote:
> > My concern is that if we merge this
> > 
> >         ioctl(sgx_fd, ENCLAVE_ADD_PAGE, SGX_PROT_READ | SGX_PROT_EXEC, ptr, size);
> > 
> > without ->mprotect(), we can't actually enforce the declared protections.  And
> > if we drop the field altogether:
> > 
> >         ioctl(sgx_fd, ENCLAVE_ADD_PAGE, ptr, size);
> > 
> > then we can't implement security_enclave_load().
> 
> To me, it's perfectly OK to have parts of the ABI which are unused.  It
> sure makes them harder to test if there are no actual users in the code,
> but if it solves a real problem with the ABI, I'm fine with it.
> 
> Let's see if I can put all the pieces together.
> 
> Background:
> 
> 1. SGX enclave pages are populated with data by copying data to them
>    from normal memory via: ioctl(sgx_fd, ENCLAVE_ADD_PAGE, src_ptr...);
> 2. We want to be able to restrict those normal memory data sources.  For
>    instance, before copying data to an executable enclave page, we might
>    ensure that the source is executable.
> 3. Enclave page permissions are dynamic just like normal permissions and
>    can be adjusted at runtime with mprotect() (along with a
>    corresponding special instruction inside the enclave)
> 4. The original data source may have have long since vanished at the
>    time when enclave page permission are established (mmap() or
>    mprotect())
> 
> Solution:
> 
> The solution is to force enclaves creators to declare their intent up
> front to ioctl(ENCLAVE_ADD_PAGE).  This intent can me immediately
> compared to the source data mapping (and rejected if necessary).  It is
> also stashed off and then later compared with enclave PTEs to ensure
> that any future mmap()/mprotect() operations performed by the enclave
> creator or the enclave itself are consistent with the earlier declared
> permissions.
> 
> Essentially, this means that whenever the kernel is asked to change an
> enclave PTE, it needs to ensure the change is consistent with that
> stashed intent.  There is an existing vm_ops->mmap() hook which allows
> SGX to do that for mmap().  However, there is no ->mprotect() hook.  Add
> a vm_ops->mprotect() hook so that mprotect() operations which are
> inconsistent with any page's stashed intent can be rejected by the driver.

Yes to all of the above.

> Implications:
> 
> However, there is currently no implementation of the intent checks at
> the time of ioctl(ENCLAVE_ADD_PAGE).

Correct.

> That means that the intent argument (SGX_PROT_*) is currently unused.

No, the intent argument is used (eventually) by SGX's ->mprotect()
implementation, i.e. sgx_mprotect() enforces that the actual protections are a
subset of the declared/intended protections.

If ->mprotect() is not merged, then it yes, it will be unused.  And therein
lies the problem as the kernel can't start using/enforcing the intent without
breaking userspace.  E.g. an enclave loaded with SGX_PROT_READ but mprotect()'d
with PROT_READ | PROT_EXEC would break if sgx_mprotect() came along.

One way to avoid introducing ->mprotect() would be to require all enclaves to
declare all pages with READ|WRITE|EXEC.  Then we could drop sgx_mprotect()
since the mprotect() permissions are guaranteed to be a subset of the declared
permissions.  That would have the added bonus of eliminating the per-page
checks in sgx_mmap()/sgx_mprotect(), though I've no idea if that is a
meaningful optmization or it's lost in the noise.

The big downside of requiring READ|WRITE|EXEC is that it will make life hell
for a LSM policy owner if they ever want to apply EXECMEM or EXECMOD style
restritions on enclaves, i.e. if SELinux folks want to add
security_enclave_load().

I find that I'm more or less ok with that approach, in no small part because
introducing security_enclave_load() might be a pretty big "if", e.g. security
folks may decide that they'd rather allow/deny enclaves based on the
measurement or signer of the enclave and eschew per-page checks entirely.

> --
> 
> Is that all correct?  Did I miss anything?
