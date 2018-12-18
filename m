Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CD7C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 01:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D46F92080D
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 01:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbeLRBkU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 20:40:20 -0500
Received: from mga06.intel.com ([134.134.136.31]:37610 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbeLRBkU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 20:40:20 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 17:40:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,367,1539673200"; 
   d="scan'208";a="101457034"
Received: from unknown (HELO localhost) ([10.249.254.218])
  by orsmga006.jf.intel.com with ESMTP; 17 Dec 2018 17:40:10 -0800
Date:   Tue, 18 Dec 2018 03:40:08 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181218014008.GD333@linux.intel.com>
References: <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <beea8ad3-a607-5478-ad87-b8dd33e86146@intel.com>
 <20181217194913.GD29785@linux.intel.com>
 <16fdd37a-b9cc-1045-1497-2cfff6af176a@intel.com>
 <CALCETrUhVDxMAtpyn5ahsTFwhJkzWxKa5Ur8q4FuVaKLmSyYHQ@mail.gmail.com>
 <826f6a5a-fdf6-e7e5-d2d8-bcdc57c016fe@intel.com>
 <CALCETrX_7g+GYj2hHvFjodPw_ryrVTQdF2M3p+KYNTBUOhg-8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX_7g+GYj2hHvFjodPw_ryrVTQdF2M3p+KYNTBUOhg-8g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 12:10:17PM -0800, Andy Lutomirski wrote:
> On Mon, Dec 17, 2018 at 12:03 PM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 12/17/18 11:55 AM, Andy Lutomirski wrote:
> > >> You're effectively rebuilding reverse-mapping infrastructure here.  It's
> > >> a frequent thing for the core VM to need to go from 'struct page' back
> > >> to the page tables mapping it.  For that we go (logically)
> > >> page->{anon_vma,mapping}->vma->vm_mm->pagetable.
> > > This is a bit outside my expertise here, but doesn't
> > > unmap_mapping_range() do exactly what SGX wants?
> >
> > There's no 'struct page' for enclave memory as it stands.  That means no
> > page cache, and that means there's no 'struct address_space *mapping' in
> > the first place.
> >
> > Basically, the choice was made a long time ago to have SGX's memory
> > management live outside the core VM.  I've waffled back and forth on it,
> > but I do still think this is the right way to do it.
> 
> AFAICS a lack of struct page isn't a problem.  The core code seems to
> understand that address_space objects might cover non-struct-page
> memory.  Morally, enclave memory is a lot like hot-unpluggable PCI
> space.

I'm fine using it if it works. Will try it for v19.

/Jarkko
