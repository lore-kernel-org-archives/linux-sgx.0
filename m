Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990A9C433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  1 Feb 2022 16:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240949AbiBAQPU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 1 Feb 2022 11:15:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:28388 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240946AbiBAQPU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 1 Feb 2022 11:15:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643732119; x=1675268119;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=ABxBRw5Lv2CTY5oDa4cCUXQTrJsTDTFc3F9QyuxkoxA=;
  b=mXE+D0Q91mat1vQiw0at9BCmjQOLyjwE8Upjb/hYedvDN3UEvhFFsFCH
   kp/FJtHJI5NM9MartgLvp33ydnjG5vPRbqq5ODg6l2ZQt+2yTHz92jFuO
   05ubQiRsdkKYI7CUJVxHXX4sOlgJMVsWMwcEHWduFl4Rk8QNCHo1aeu5H
   gd6SmPd0wjr0YWKboNsHTL3O4r5PqFGkcacaVC3AEzqRX80+5/GEpmqZP
   YkQMBpiUpEfUA+fC6DwbfwfmpQxUzOvC8ACS6cvj/cIeBzdqq2mraDcDn
   xNJGokV/9JwCFXXwz3m7nTTkUg+lBj3KSE1wwU7LrjwkGpYox0psOpMo3
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="228384206"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="228384206"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 08:15:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="537864885"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.255.38.31])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 01 Feb 2022 08:15:06 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-sgx@vger.kernel.org, "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     dave.hansen@linux.intel.com, kristen@linux.intel.com,
        cedric.xing@intel.com, haitao.huang@intel.com,
        reinette.chatre@intel.com, bp@alien8.de, seanjc@google.com,
        luto@kernel.org, nathaniel@profian.com, harald@profian.com
Subject: Re: aesmd availability
References: <YfPAh8m1c9LI6plB@iki.fi> <YfPYfsnjYXQsY6Jz@iki.fi>
Date:   Tue, 01 Feb 2022 10:15:04 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1gw53ee3wjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <YfPYfsnjYXQsY6Jz@iki.fi>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko

On Fri, 28 Jan 2022 05:50:22 -0600, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Fri, Jan 28, 2022 at 12:08:07PM +0200, Jarkko Sakkinen wrote:
>> I noticed that with aesmd the only feasible way to host it is to make a
>> VM for it because:
>>
>> - A beter predictable round-trip time for attestation.
>> - In the worst case, attestation could be potentially blocked.
>>

I don't fully understand your description here. Based on what you said  
below, I think you are talking about how to improve (control of) EPC  
allocation for apps in case of over-subscription (i.e., when EPC runs  
out). My comments below are with this understanding.

In case you think there are limitations of aesmd implementation that  
prevent aesmd from being hosted in other than a separate VM, please create  
an issue on the corresponding GitHub.

>> Should the driver have a page locking mechanism to make this more  
>> robust,
>> or do we want to satisfy to this? I'm not 100% sure what'd be the right
>> path forward, just pointing out a potential availability issue.
>

Current swapping would ensure the last active pages be loaded so it gives  
some level of insurance that aesmd would be able to run as long as there  
is swapping RAM and other apps are not super active during attestation.

I think SGX cgroups support should help address this concern in a general  
way, which was discussed before and I think is in plan.

Not sure if lock works better, could you explain how it work?
