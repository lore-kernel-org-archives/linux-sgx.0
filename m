Return-Path: <SRS0=9T+I=DB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7B1C4346E
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 23:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB37723899
	for <linux-sgx@archiver.kernel.org>; Thu, 24 Sep 2020 23:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgIXXFJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 24 Sep 2020 19:05:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:33534 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgIXXFJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 24 Sep 2020 19:05:09 -0400
IronPort-SDR: pDiq48MlVdehx9sqlaOdTwzCAwhEmeeslkBXXOhMal92aNdOgXhVPe1JLTnURxysF8KVRgxppT
 zybrX02Q6ZLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="140799556"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="140799556"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 16:05:09 -0700
IronPort-SDR: DTeNHZ6aog3FVIKOt9A/8jA2Wdb4mMOF4QGxpICuPDHyv4eLWgFVqufJ3s+0wSn9qe3458UIjy
 tpNmprXiVeXg==
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="310579735"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 16:05:08 -0700
Date:   Thu, 24 Sep 2020 16:05:06 -0700
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
Message-ID: <20200924230501.GA20095@linux.intel.com>
References: <20200922053515.GA97687@linux.intel.com>
 <20200922164301.GB30874@linux.intel.com>
 <20200923135056.GD5160@linux.intel.com>
 <op.0rgp5h0hwjvjmi@mqcpg7oapc828.gar.corp.intel.com>
 <20200924192853.GA18826@linux.intel.com>
 <c680f7bd-2d82-6477-707f-cd03aae4b4aa@intel.com>
 <20200924200156.GA19127@linux.intel.com>
 <e4bcb25f-581a-da93-502b-b8f73e28286a@intel.com>
 <20200924202549.GB19127@linux.intel.com>
 <e25bfeaa-afb4-3928-eb80-50d90815eabb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e25bfeaa-afb4-3928-eb80-50d90815eabb@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 24, 2020 at 01:54:09PM -0700, Dave Hansen wrote:
> On 9/24/20 1:25 PM, Sean Christopherson wrote:
> ...
> >> Why don't we just declare enclave memory as "out of scope for noexec" in
> >> the same way that anonymous memory is, and just discard this patch?
> >> That doesn't seem too much of a stretch.
> > 
> > Because we lose line of sight to LSM support.  Without enforcing "declare perms
> > at load time" in the initial series, we would create an ABI where userspace
> > could load an enclave page with only READ permissions and then map the enclave
> > with whatever permissions it wants, without any convenient way for SGX to call
> > into the LSM.
> 
> This argument holds no water for me.  LSMs are all about taking what
> would otherwise be perfectly acceptable behavior and breaking them in
> the name of security.  They fundamentally break applications that used
> to work just fine and also did totally sane things.

It's not about LSMs breaking things, they can obviously do that without any
help.  The concern is that, unless we lay the groundwork now, adding support
for LSMs in the future will break existing applications or create an unholy
mess of an ABI.

If we want to support LSM policy for enclave page permissions, checking LSM
policies at load time and hooking mprotect() to enforce the policy at run
time is by far the cleanest solution of the many ideas we discussed.

The problem is that enforcing permissions via mprotect() needs to be done
unconditionally, otherwise we end up with weird behavior where the existence
of an LSM will change what is/isn't allowed, even if the LSM(s) has no SGX
policy whatsover.

And on the flip side, enforcing permissions unconditionally will break
backwards compatibility.

I'm a-ok if we want to kill off the ->mprotect() hook, so long as we
acknowledge that in doing so we are likely throwing in the towel on supporting
LSM policies for enclave page permissions.
