Return-Path: <SRS0=3+dw=PS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB00C43387
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 17:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA28C20685
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Jan 2019 17:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfAJRnn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Jan 2019 12:43:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:49121 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbfAJRnn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Jan 2019 12:43:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2019 09:43:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,462,1539673200"; 
   d="scan'208";a="133452355"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.152])
  by fmsmga002.fm.intel.com with ESMTP; 10 Jan 2019 09:43:34 -0800
Date:   Thu, 10 Jan 2019 19:43:33 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20190110174333.GI6589@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jan 08, 2019 at 07:27:11PM +0000, Huang, Kai wrote:
> > >
> > > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > > opening a new instance of /dev/sgx for each encalve?
> > 
> > Directly associating /dev/sgx with an enclave means /dev/sgx can't be used
> > to provide ioctl()'s for other SGX-related needs, e.g. to mmap() raw EPC and
> > expose it a VM.  Proposed layout in the link below.  I'll also respond to
> > Jarkko's question about exposing EPC through /dev/sgx instead of having
> > KVM allocate it on behalf of the VM.
> > 
> > https://lkml.kernel.org/r/20181218185349.GC30082@linux.intel.com
> 
> Hi Sean,
> 
> Sorry for replying to old email. But IMHO it is not a must that Qemu needs to open some /dev/sgx and allocate/mmap EPC for guest's virtual EPC slot, instead, KVM could create private slot, which is not visible to Qemu, for virtual EPC, and KVM could call core-SGX EPC allocation API directly.
> 
> I am not sure what's the good of allowing userspace to alloc/mmap a raw EPC region? Userspace is not allowed to touch EPC anyway, expect enclave code.
> 
> To me KVM creates private EPC slot is cleaner than exposing /dev/sgx/epc and allowing userspace to map some raw EPC region. 
> 
> Thanks,
> -Kai

Side-note: this particular use case does not necessarily be solved in
the first upstream patch set, does it? Just try to keep the patch set
as small as possible (still be a huge one).

/Jarkko
