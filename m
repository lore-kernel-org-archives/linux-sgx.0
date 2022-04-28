Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74180C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 22:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353063AbiD1W4t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 18:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350157AbiD1W4t (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 18:56:49 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF2232EDB
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 15:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651186413; x=1682722413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+HRFGv+HWenamRzO+3f+IfPtvjW2M0UICSPYOCpXj2c=;
  b=JJ5X5+f8KRLLggKNfR/rhPo4j8COsoG9lPzNOE4ckZAHl9BYJ77WjPO3
   86gTb0q2RcSx85AeSStXdgf2YdLxlTLvfktxR/qomV6XjcCOA5jyarNK+
   D0ek3K5p2tczcDwHGBFQvUKWfYDQO2xD7Ayx9QVPr+T3hAMTQqZfGW7zQ
   ac5sBf3FYdQkWoM6ksZXbScvlQLtqlKx/D7L7c0MFB4Dc91/td6okxXQY
   hfpPWLU2UB/aY7HS2VvFk+HWvLLoZCw0QDl1TalhMdzEx1/UvqmP3Hwo2
   q2uHRxdZELHMqVNgZBOJiWJgilUT5YFnIRQ4jPpDwhjK8lXaDiNF0cyXd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="264037632"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="264037632"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:53:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="565838034"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:53:33 -0700
Message-ID: <5ae310cc-ed2d-9380-10ad-4ee27f8a5478@intel.com>
Date:   Thu, 28 Apr 2022 15:53:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 1/4] x86/sgx: Do not free backing memory on
 ENCLS[ELDU] failure
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <6fad9ec14ee94eaeb6d287988db60875da83b7bb.1651171455.git.reinette.chatre@intel.com>
 <a43b87b3-ba9f-c442-295c-cef84d6f8318@intel.com>
 <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <2cd90e97-6cbd-c901-949b-058348bcd78b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/28/22 15:20, Reinette Chatre wrote:
> Hi Dave,
> 
> On 4/28/2022 2:30 PM, Dave Hansen wrote:
>> On 4/28/22 13:11, Reinette Chatre wrote:
> 
>> Are there any transient, recoverable errors that can come back from
>> ELDU?  If so, this makes a lot of sense.  If not, then it doesn't make a
>> lot of sense to preserve the swapped-out content because they enclave is
>> going to die anyway.
> 
> Good point.
> 
> Theoretically ELDU could encounter a page fault while accessing the 
> regions it needs to read from and write to. These faults are passed
> through and the instruction would return with a #PF that is
> propagated with the page fault handler returning SIGBUS.

We don't have to worry about those, though, do we?  We're operating
entirely on kernel mappings that won't cause #PF.

> Even so, this flow also impacts the SGX2 flows that need to load pages from
> the backing store. In this case the kernel would pass it as an error
> (-EFAULT) to the runtime but it would not result in the
> enclave being killed. If it was a #PF that caused the issue then
> perhaps theoretically the SGX2 instruction has a chance of succeeding
> if the runtime attempts it again? 

How are the SGX2 flows different than what we have now?

I also looked a little deeper at this transient failure problem.  The
ELDU documentation also mentions a possible error code of:

	SGX_EPC_PAGE_CONFLICT

It *looks* like there can be conflicts on the SECS page as well as the
EPC page being explicitly accessed.  Is that a possible problem here?
