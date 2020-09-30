Return-Path: <SRS0=ssgJ=DH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C10C4363D
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 20:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E7B2071E
	for <linux-sgx@archiver.kernel.org>; Wed, 30 Sep 2020 20:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgI3UqC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 30 Sep 2020 16:46:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:49908 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3UqC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 30 Sep 2020 16:46:02 -0400
IronPort-SDR: +Oa67nbCvdyYZkHU8T7Od02vrO7NwA/+TLsxo5s+JZ/OCMMj2UKzIq7UPsZqyPaBOYEHWYGUgm
 Nr50rMMPwvWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="161778308"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="161778308"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 13:46:00 -0700
IronPort-SDR: pQy5+xdi+dCfXd1EV7PUzO7WtjSFv7eFz+ag21CY/Wg9Q11cYwxAM7rsUaHVlujCSSHRjylIca
 s2MF3NKfxnGw==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="312725040"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.209.12.56]) ([10.209.12.56])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 13:45:58 -0700
Subject: Re: [PATCH] x86/vdso: Remove retpoline from SGX vDSO call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
References: <20200930140108.48075-1-jarkko.sakkinen@linux.intel.com>
 <92578646-83a4-606c-b251-4d80cb62399c@intel.com>
 <20200930142017.GA49393@linux.intel.com>
 <112ad81e-16ab-d6e0-09e7-3658874434f7@intel.com>
 <20200930152806.GA52739@linux.intel.com>
 <20200930154349.GB32672@linux.intel.com>
 <17231664-3735-2d57-fbfa-9af838e224ab@intel.com>
 <f5021328-2fab-a404-108f-e28e26e6996c@fortanix.com>
 <cc222137-e488-c48a-ca66-000e74944eea@citrix.com>
 <20200930192541.GA60658@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <741b45d0-3833-4e5d-5974-81634d1b55eb@intel.com>
Date:   Wed, 30 Sep 2020 13:45:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200930192541.GA60658@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 9/30/2020 12:25 PM, Jarkko Sakkinen wrote:
> On Wed, Sep 30, 2020 at 07:09:33PM +0100, Andrew Cooper wrote:
>> Honestly, my advice would be to leave it unprotected for now.  Anyone
>> who managed to figure out the rest of the practical userspace issues
>> will probably have a much better idea of what can/should be done in this
>> case.
>>
>> If that doesn't sit well with people, then the next best would probably
>> be LFENCE; CALL *reg/mem; LFENCE to cover as many of the corner cases as
>> possible without being incompatible with CET.  Its not as if this
>> callback is the slow aspect of entering/exiting SGX mode.
>>
>> ~Andrew
> 
> I tend to agree. We cannot drive changes based on unknown unknowns.
> 
> And I don't see why we could not add boot time patching of retpoline
> even after the code is in the mainline kernel, if something ever
> pushes to that direction.
> 
> /Jarkko
> 
I agree. It'll be compatible with CET. The overhead of LFENCE is 
negligible comparing to entering/exiting SGX mode.
