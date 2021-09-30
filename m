Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF6FC433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Sep 2021 18:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 836D8619F9
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Sep 2021 18:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352973AbhI3SEa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:04:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:8475 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353024AbhI3SEX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 Sep 2021 14:04:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="310797540"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="310797540"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 11:02:35 -0700
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="555882303"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 11:02:35 -0700
Date:   Thu, 30 Sep 2021 11:02:33 -0700
From:   "Luck, Tony" <tony.luck@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Zhang, Cathy" <cathy.zhang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Subject: Re: [PATCH v7 3/7] x86/sgx: Initial poison handling for dirty and
 free pages
Message-ID: <YVX7uWE072rXBH0T@agluck-desk2.amr.corp.intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
 <20210927213452.212470-1-tony.luck@intel.com>
 <20210927213452.212470-4-tony.luck@intel.com>
 <3efcda381b49651004e230f6ef008032842db1f9.camel@kernel.org>
 <ca3bb671a49141608ac981012091c3ea@intel.com>
 <1702295227b9276e051a0efee8af1475cba27407.camel@kernel.org>
 <YVOA1/AFFXmR6Uiw@agluck-desk2.amr.corp.intel.com>
 <6e4e24ab222e0d8eba051cd01218a9b716217b7a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e4e24ab222e0d8eba051cd01218a9b716217b7a.camel@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Sep 30, 2021 at 05:40:18PM +0300, Jarkko Sakkinen wrote:
> On Tue, 2021-09-28 at 13:53 -0700, Luck, Tony wrote:
> > > Couldn't it be a blob with 8 bytes for each address?
> > 
> > It could be a blob. But that would require some perl/python
> > instead of simple shell to do the above persistence trick.
> 
> The way I've understood it, a list of values breaks sysfs conventions.
> There can be only single value per attribute. Even, if the blob is
> interpreted as a list of integers, it is still a value, as far as sysfs
> is concerned.
> 
> I'd also consider programs written with C, or perhaps Rust, when we
> (ever) add any new sysfs for SGX. In my opinion, it makes sense to make
> any uapi things we add accesible to as many tools as we can.
> 
> Such a trivially constructed blob is not enormously hard to parse in any
> language, but at least I don't enjoy parsing list of strings in C code,
> whereas loading a blob is effortless.
> 
> This kind of shows why the current sysfs conventions make sense in the
> first place: they enforce to design attributes in the manner that they
> are as reachable as possible. That's why I would follow the conventions
> in a strict manner.
> 
> Finally, I would make a proper sysfs attribute out of this (and a separate
> patch), which would be available per node.

Those are all good points. I'm going to drop any interface from this
series (because that's above and beyond the goal of "basic machine check
support"). We can spend some time to come up with the right interface
and add that in a future series.

-Tony
