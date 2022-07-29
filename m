Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E518C00144
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Jul 2022 19:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbiG2Thp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Jul 2022 15:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237057AbiG2Tho (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 29 Jul 2022 15:37:44 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2101987F68
        for <linux-sgx@vger.kernel.org>; Fri, 29 Jul 2022 12:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659123464; x=1690659464;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=wf7I011tT7oJsnGUkz3GvRJvv1OIPh4wvpfwTQGkGzQ=;
  b=E5PxT9aPVaAyp7pAMi27/0hAP181tkYCRuSh6mdKz/GO2QKcnYLtmjvR
   lWKbOpDLxXsruzdahRR43Chbb6f0tKLk7B+tzsul3MUGEbS11vU3BUykh
   6wjR4DTPTTKKVXmQ7iiezIsN/NAENffCwcRgT0la6sTq/xyevNmba3d5f
   deLrMSzOTHSNGp5pdMTa4HAd29apxsd1nfn5wRLdcn4f9RSdpUOdWKDTv
   jnmWUkOBjILW1OYXwAaptFAutywnrCugV18HsPqbvXrOR3fcyGO+k51uJ
   +WTc76yr66AoQnM/uN1XIMzyDJzta0Lq5GG3/vjALmUdi3tQqsL8BOxMY
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="271875692"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="271875692"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 12:37:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="598346598"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.209.150.228])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 29 Jul 2022 12:37:38 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>
Cc:     "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of EPC
 pages
References: <DM8PR11MB55912A7F47A84EC9913A6352F6999@DM8PR11MB5591.namprd11.prod.outlook.com> <1600d7b3-24c2-7455-4a7f-56366ccd03aa@intel.com> <DM8PR11MB55911E8F9DA739F215FD1D90F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
Date:   Fri, 29 Jul 2022 14:37:32 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1p214u15wjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <DM8PR11MB55911E8F9DA739F215FD1D90F6999@DM8PR11MB5591.namprd11.prod.outlook.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 29 Jul 2022 14:14:15 -0500, Dhanraj, Vijay  
<vijay.dhanraj@intel.com> wrote:

> Hi Dave,
>
> Tried with the latest tip and I still observe the issue. I tried 2G, 4G  
> and 8G sized requests and as before, 2GB size requests works fine but  
> 4GB and 8GB requests failed.
>
> Commit I have applied my test patch:
> commit 038ef9928e1acb37bbe808c23a421189f1fd96cb (origin/x86/sgx)
> Merge: e0a5915f1cca e0dccc3b76fb
> Author: Ingo Molnar <mingo@kernel.org>
> Date:   Tue Jul 26 09:14:28 2022 +0200
>
>     Merge tag 'v5.19-rc8' into x86/sgx, to resolve conflicts
>
> Kernel version:
> Linux sdp 5.19.0-rc8-custom #1 SMP PREEMPT_DYNAMIC Fri Jul 29 10:28:25  
> PDT 2022 x86_64 x86_64 x86_64 GNU/Linux
>

Using a kernel built at the same commit, I did the same test on another  
machine with 4G EPC reported by the kernel log and reproduced the failures  
only on 5th run for both 4G and 8G size requests (set by edmm_size). The  
failure seems to stick for subsequent runs but I did not run more than 7  
times for each case so can't say definitely about that.

Thanks
Haitao

>
>> -----Original Message-----
>> From: Hansen, Dave <dave.hansen@intel.com>
>> Sent: Friday, July 29, 2022 9:38 AM
>> To: Dhanraj, Vijay <vijay.dhanraj@intel.com>; Chatre, Reinette
>> <reinette.chatre@intel.com>; dave.hansen@linux.intel.com;
>> jarkko@kernel.org; linux-sgx@vger.kernel.org
>> Cc: Huang, Haitao <haitao.huang@intel.com>
>> Subject: Re: Support SGX2 V5: Seg-fault with EACCEPT for large number of
>> EPC pages
>>
>> On 7/29/22 09:01, Dhanraj, Vijay wrote:
>> > Huang, Haitao and I created a simple patch to repro this issue using  
>> the SGX
>> selftests and we do see the issue when using V5 (5.18.0-rc5) but cannot
>> repro the issue in V4 (5.18.0-rc2). Not sure if this is a driver issue  
>> or kernel,
>> can you please check?
>>
>> Thanks for the report.
>>
>> Could you please try the code that's going to go to Linus shortly?   
>> It's really
>> the only version that matters at this point?
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/sgx

