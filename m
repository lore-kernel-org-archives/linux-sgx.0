Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584C7C4727C
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 00:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CD392075A
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 00:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgI3AUj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 29 Sep 2020 20:20:39 -0400
Received: from mga04.intel.com ([192.55.52.120]:29850 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgI3AUj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 29 Sep 2020 20:20:39 -0400
IronPort-SDR: StmOE3TAv8WaDrp2c30PgsOLFGvkfQIWofZLJobXpfyrOrSagg0R8h7QKKEa9yudKR363mayo7
 pTlflxjSN15Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="159709134"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="159709134"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:20:35 -0700
IronPort-SDR: LKB/3uj8QGgmJ53rwe5qpgySPUoJ8SsdSvu4YhNqxbhX2f3fN6JWiToU22vU/E19MXH6JOnVju
 DGzLNQmhhccg==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="494359933"
Received: from jwilliam-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.189])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 17:20:27 -0700
Date:   Wed, 30 Sep 2020 03:20:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
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
Message-ID: <20200930002024.GA805586@linux.intel.com>
References: <20200928201959.GA3856@linux.intel.com>
 <E16AF0FA-3017-4323-BDD9-56DCA33CED74@amacapital.net>
 <20200929040521.GC301037@linux.intel.com>
 <1b1bd1f8-210d-486a-b038-2d6eea9d35cd@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b1bd1f8-210d-486a-b038-2d6eea9d35cd@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Sep 29, 2020 at 07:24:24AM -0700, Dave Hansen wrote:
> On 9/28/20 9:05 PM, Jarkko Sakkinen wrote:
> > On Mon, Sep 28, 2020 at 06:37:54PM -0700, Andy Lutomirski wrote:
> >> I don’t personally care that much about EMODPE but, you could probably
> >> get the point across with something like:
> >>
> >> SGX’s EPCM permission bits do not obviate the need to enforce these
> >> rules in the PTEs because enclaves can freely modify the EPCM
> >> permissions using EMODPE.
> >>
> >> IOW, EMODPE is not really special here; rather, EMODPE’s existence
> >> demonstrates that EADD / EEXTEND are not special.
> > 
> > So I did "disagree and commit" with this one. I'm not actually
> > diagreeing on anything what Dave wrote, on the contrary it is an
> > understandable high level description. I just thought that it would not
> > hurt to remark that the ISA contains such peculiarities as EMODPE.
> > 
> > I did only very rudimentary clean up for the text (e.g. fix the ioctl
> > name, add shortt summary and not much else).
> > 
> > Does not make sense to waste more time to this. I'll move on to
> > implement the missing boot time patching for the vDSO so that we
> > get the next version out.
> > 
> > "
> > mm: Add 'mprotect' hook to struct vm_operations_struct
> > 
> > Background
> > ==========
> > 
> > 1. SGX enclave pages are populated with data by copying data to them
> >    from normal memory via ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).
> > 2. We want to be able to restrict those normal memory data sources.  For
> >    instance, before copying data to an executable enclave page, we might
> >    ensure that the source is executable.
> 
> I know I wrote that.  I suck, and I wrote it in a changelog-unacceptable
> way.  Folks dislike the use of "we" in these things.  Here's a better
> version:
> 
>   2. It is desirable to be able to restrict those normal memory data
>      sources.  For instance, the kernel can ensure that the source is
>      executable, before copying data to an executable enclave page.
> 
> > 3. Enclave page permissions are dynamic just like normal permissions and
> >    can be adjusted at runtime with mprotect() (along with a
> >    corresponding special instruction inside the enclave).
> > 4. The original data source may have have long since vanished at the
> >    time when enclave page permission are established (mmap() or
> >    mprotect()).
> > 
> > Solution
> > ========
> > 
> > The solution is to force enclaves creators to declare their intent up front
> > to ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).  This intent can me immediately
> > compared to the source data mapping (and rejected if necessary).  It is
> > also stashed off and then later compared with enclave PTEs to ensure that
> > any future mmap()/mprotect() operations performed by the enclave creator or
> > the enclave itself are consistent with the earlier declared permissions.
> 
> Let's also say "... or *requested* by the enclave itself ...", since the
> enclave itself can't directly make syscalls.

Yes, it is definitely more understandable way to say it. Do you mind
if I rephrase it as:

"It is also stashed off and then later compared with enclave PTEs to
ensure that any future mmap()/mprotect() operations performed by the
enclave creator or requested the enclave by itself (e.g. by issuing
ECLU[EMODPE]) are consistent with the earlier declared permissions."

I'd just mention EMODPE as an example, but I'm also perfectly fine
leaving that out :-) Not a big deal for me.

Also, should there be commas, i.e. ", or requested the enclave by
itself,"? I suck with English comma rules.

> > Essentially, this means that whenever the kernel is asked to change an
> > enclave PTE, it needs to ensure the change is consistent with that stashed
> > intent.  There is an existing vm_ops->mmap() hook which allows SGX to do
> > that for mmap().  However, there is no ->mprotect() hook.  Add a
> > vm_ops->mprotect() hook so that mprotect() operations which are
> > inconsistent with any page's stashed intent can be rejected by the driver.
> > 
> > Implications
> > ============
> > 
> > However, there is currently no implementation of the intent checks at the
> > time of ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES).  That means that the intent
> > argument (SGX_PROT_*) is currently unused.
> 
> This was incorrect to say.  Sean corrected me on this point.  Could you
> look through the thread and incorporate that?

OK, so we are probably talking about [1] here, right?

There are at least two checks done with and without the callback:

A. TCS pages are required to be passed with zero EPCM permissions,
   the reason being that CPU will silently overwrite its permissions
   zero. This check resides in sgx_validate_secinfo() [2].
B. noexec partitions are unconditionally disallowed. This check
   resides in __sgx_encl_add_page() [2].

TCS pages are funky in the way that they are also required to be
mapped as RW. OK, then you might argue that why not just require
RW as ioctl supplied permissions. That would cause a mismatch with
CPU calculated MRENCLAVE and one calculated to SIGSTRUCT. I've
written in past quite length explanation of this to the kdoc
of sgx_ioc_enclave_add_pages() [2].

This was something that I did not find from Sean's response.

To encompensate all this information in a paragraph, I'd write along
the lines of

"ioctl(fd, SGX_IOC_ENCLAVE_ADD_PAGES, ...) checks for every page that
Thread Control Structure (TCS) pages are always added with zero
permissions and no pages are sourced from noexec partitions. TCS pages
are pages that work as entry points to the enclave. This is the basic
acceptance criteria for any enclave page before it gets mapped.

After finishing this, the ioctl will project the enclave permissions to
the corresponding VMA permissions and stores the result for later
lookup.  For regular pages this is an identity mapping but as an
exception TCS pages are unconditionally mapped as RW VMA permssion even
though their enclave permissions are zero. This required by the ISA.

This information will be used by sgx_mmap() and sgx_vma_protect() to
enforce that higher permissions than the projected permissions will
not be used by checking this for each every page in the address
range.

By doing this, we give assets for LSM's to make decisions during the
build time based on projected VMA permissions and the source VMA
(either a file or anonymous mapping) that hold when the enclave is
finally mapped to the visible memory."

Is this sufficient?

[1] https://lore.kernel.org/linux-sgx/20200915112842.897265-1-jarkko.sakkinen@linux.intel.com/T/#m7e84af96d63dd8ec528422cfc942f42e3bdf4356
[2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git/tree/arch/x86/kernel/cpu/sgx/ioctl.c

/Jarkko
