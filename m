Return-Path: <SRS0=ibNi=PT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3AAC43444
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 16:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8D0520675
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jan 2019 16:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfAKQII (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Jan 2019 11:08:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:11617 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbfAKQII (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Jan 2019 11:08:08 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jan 2019 08:08:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,466,1539673200"; 
   d="scan'208";a="116039977"
Received: from gandrejc-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.144])
  by fmsmga008.fm.intel.com with ESMTP; 11 Jan 2019 08:07:59 -0800
Date:   Fri, 11 Jan 2019 18:07:58 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
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
Message-ID: <20190111160758.GC12093@linux.intel.com>
References: <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <105F7BF4D0229846AF094488D65A0989355A45B6@PGSMSX112.gar.corp.intel.com>
 <20190108220946.GA30462@linux.intel.com>
 <CALCETrU7Zb8L8eTYZg3bAB1Gfw1orUfeQmXjVy1_R-kfBeweVA@mail.gmail.com>
 <20190110174550.GJ6589@linux.intel.com>
 <CALCETrXMW+tUyTaMmmdhGciqbktiqH6NCuLZbBqfhcnzCgMbnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXMW+tUyTaMmmdhGciqbktiqH6NCuLZbBqfhcnzCgMbnA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 10, 2019 at 01:36:15PM -0800, Andy Lutomirski wrote:
> > Does it even matter if just leave EINITTOKENKEY attribute unprivileged
> > given that Linux requires that MSRs are writable? Maybe I'll just
> > whitelist that attribute to any enclave?
> >
> 
> I would at least make it work like the PROVISIONKEY bit (or whatever
> it's called).  Or just deny it at first.  It's easy to start allowing
> it if we need to down the road, but it's harder to start denying it.

I think that would be a great idea to add another file to securityfs
for this. Would fit perfectly to your "systemd privilege sharing"
daemon example. Here consistency would be really nice.

/Jarkko
