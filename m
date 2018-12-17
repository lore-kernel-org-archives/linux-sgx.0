Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A77C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 22:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3034214C6
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 22:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbeLQWgn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 17:36:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:56555 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727597AbeLQWgn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 17:36:43 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 14:36:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,366,1539673200"; 
   d="scan'208";a="102267709"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2018 14:36:42 -0800
Date:   Mon, 17 Dec 2018 14:36:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-ID: <20181217223642.GH12491@linux.intel.com>
References: <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <beea8ad3-a607-5478-ad87-b8dd33e86146@intel.com>
 <20181217194913.GD29785@linux.intel.com>
 <16fdd37a-b9cc-1045-1497-2cfff6af176a@intel.com>
 <CALCETrUhVDxMAtpyn5ahsTFwhJkzWxKa5Ur8q4FuVaKLmSyYHQ@mail.gmail.com>
 <826f6a5a-fdf6-e7e5-d2d8-bcdc57c016fe@intel.com>
 <CALCETrX_7g+GYj2hHvFjodPw_ryrVTQdF2M3p+KYNTBUOhg-8g@mail.gmail.com>
 <18800fdc-a2e1-39a3-9ee5-0065865ea052@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18800fdc-a2e1-39a3-9ee5-0065865ea052@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 12:15:47PM -0800, Dave Hansen wrote:
> On 12/17/18 12:10 PM, Andy Lutomirski wrote:
> >> There's no 'struct page' for enclave memory as it stands.  That means no
> >> page cache, and that means there's no 'struct address_space *mapping' in
> >> the first place.
> >>
> >> Basically, the choice was made a long time ago to have SGX's memory
> >> management live outside the core VM.  I've waffled back and forth on it,
> >> but I do still think this is the right way to do it.
> > AFAICS a lack of struct page isn't a problem.  The core code seems to
> > understand that address_space objects might cover non-struct-page
> > memory.  Morally, enclave memory is a lot like hot-unpluggable PCI
> > space.
> 
> Yeah, this is true.  The existing code seems to make it all the way from
> unmap_mapping_range() down to zap_page_range() without 'struct page'.
> 
> Overall, I think what Andy is saying here is that an open(/dev/sgx)
> should give you a "unique" enclave fd.  That fd can end up mapped into
> one or more processes either via fork() or the other ways fds end up
> getting handed around.  mmap() of this fd would be *required* to be
> MAP_SHARED.  That means you don't need to support COW, and the semantics
> are the same as any other MAP_SHARED mapping: children and parents and
> anybody mmap()'ing it must all coordinate.
> 
> This sounds interesting at least.  It might lead to an unholy mess in
> the driver, or it might be a great cleanup.  But, it does sound like
> something that would both potentially simplify the semantics and the
> implementation.

It's very similar to KVM's model, which has proven to be fairly robust,
so I don't think it'll be an unholy mess (famous last words).  It
probably won't be a "great" cleanup per se, but it definitely should
make the code more maintainable in the long run.

The other interesting aspect of the enclave fd approach is that it would
allow userspace to *execute* an enclave from multiple processes, so long
as it did the necessary multiplexing of pthreads to enclave threads.  I
think SGX2 instructions (dynamic EPC management) would even allow adding
new enclave threads on-demand.
