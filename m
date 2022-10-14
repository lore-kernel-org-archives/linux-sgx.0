Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4E6C433FE
	for <linux-sgx@archiver.kernel.org>; Fri, 14 Oct 2022 05:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJNFl7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 14 Oct 2022 01:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiJNFl6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 14 Oct 2022 01:41:58 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521E718C423
        for <linux-sgx@vger.kernel.org>; Thu, 13 Oct 2022 22:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665726118; x=1697262118;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mi6HGRe6Fm0xCFbkeXm8zkoSkEim2URSTr/+svy6uAQ=;
  b=K9ow0DQzey2uihrwVHL1DbrDj36SekaA21rl2EPkufOWWCT/vTEHJ14n
   xRQrPt6vzRgBOHULL2x3WLwkjw4MfSesF5JzxMcERAiyuxyP42iIfm6D0
   3eM6JCxOVj7KFyIG0HS3P9S8fFeFDVb5U26sM9ExHB5ovoNNSAOBUlFrv
   X8+aqtmprHZsa02oTQzTRXgrLnhabqs3qBQIAX/Pk4yfphwaEacvwEo7q
   yIV+6JCb4bvHXfo69jTR9gHi8mKOfCLM1lF+tm+IJtTNueSjtG16Qbhtf
   xm1YLciszVVcIt3zhuRe9B3ysCc9D6APsh1JQn3GyEbsDPVMTBSzOvcTc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="369478016"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="369478016"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 22:41:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="605258356"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="605258356"
Received: from mkucejko-mobl.ger.corp.intel.com (HELO [10.213.24.166]) ([10.213.24.166])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 22:41:51 -0700
Message-ID: <bdfea917-397f-0017-fa5c-33711e09fb77@intel.com>
Date:   Thu, 13 Oct 2022 22:41:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v9 3/3] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com,
        bp@suse.de, tglx@linutronix.de
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
 <20220920063948.3556917-4-zhiquan1.li@intel.com>
 <b775a187-32ad-836f-557f-3486ef4ac8dd@intel.com>
 <14fabc80-a9fc-05b4-eda1-62f2b265e66b@intel.com>
 <f8b49a6b-44ce-9477-b2ba-39abadfbd68f@intel.com>
 <fb885d7f-388c-6a53-798b-06805fefca3d@intel.com>
 <b2dd91b1-9b9f-6b41-4cb9-80dd99837480@intel.com>
 <00036cfe-53f5-2a3f-8b16-51029c702080@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <00036cfe-53f5-2a3f-8b16-51029c702080@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 10/13/22 22:42, Zhiquan Li wrote:
> On 2022/10/13 23:39, Dave Hansen wrote:
>> I wanted an example here of a SIGBUS that can occur from sources *OTHER*
>> than a recoverable machine check.
> Oh, got it, it should like this:
> 
> 	There is already a signal-based ABI to tell userspace about
> 	machine checks.  But, SGX does not use that ABI.  Today, the
> 	kernel delivers a generic SIGBUS if a machine check occurs when
> 	accessing SGX memory.  Userspace can not differentiate that
> 	SIGBUS from invalid address alignment, nonexistent physical
> 	address or object-specific hardware error, so it is very
> 	unlikely to be able to recover from the signal and the app will
> 	die.

That looks much better, thanks.
