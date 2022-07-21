Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33DDEC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Jul 2022 16:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiGUQ5U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Jul 2022 12:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbiGUQ5U (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Jul 2022 12:57:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9CB89A67
        for <linux-sgx@vger.kernel.org>; Thu, 21 Jul 2022 09:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658422637; x=1689958637;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qGCc4O704ik0v7UR/ZdhkTtj8YqbXxvbcKTDnuIKkeM=;
  b=Zfxksll4W6HyykLUt1CHKD8hc3LajinF6dPwNi6xmtdT1fqfXNDh+DEI
   0OUk2aIHUfSeEMOpxknxCESvIx6tdOE2EmDy/2QFyXYgZ6EHMpDswpaM7
   HRm9zIhRG6Mes9yBhA17EgzC6HY6swPsesiGnd4OoRD/ZVeYOTbqkPIaE
   dB3/z5D9e56s01etOutVcvBExLpLAXH5LXvbEDi/ARaltDq1yJKBsHm2D
   jSuzma5QVgS62ZSkXXwIq4ia6LQOSGj4W80jw7/qBODLcmJxH9R5K9uri
   tsLinTKesn2nOBubrMOfVI/rgoEzvcyz2+ijHh7joHPmHJTM0GQ1EkrmR
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="287857809"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="287857809"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:57:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="573818652"
Received: from vasantgx-mobl.amr.corp.intel.com (HELO [10.212.244.191]) ([10.212.244.191])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 09:57:16 -0700
Message-ID: <b70b4902-24f5-8a76-5e72-e51de20d1d59@intel.com>
Date:   Thu, 21 Jul 2022 09:57:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v5 3/3] x86/sgx: Fine grained SGX MCA behavior for normal
 case
Content-Language: en-US
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com, jarkko@kernel.org, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
 <20220622093705.2891642-4-zhiquan1.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20220622093705.2891642-4-zhiquan1.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/22/22 02:37, Zhiquan Li wrote:
> When the application accesses a SGX EPC page with memory failure, the
> task will receive a SIGBUS signal without any extra info, unless the
> EPC page has SGX_EPC_PAGE_KVM_GUEST flag. However, in some cases,
> we only use SGX in sub-task and we don't expect the entire task group
> be killed due to a SGX EPC page for a sub-task has memory failure.
> 
> To fix it, we extend the solution for normal case. That is, the SGX
> regular EPC page with memory failure will trigger a SIGBUS signal with
> code BUS_MCEERR_AR and additional info, so that the user has opportunity
> to make further decision.
> 
> Suppose an enclave is shared by multiple processes, when an enclave page
> triggers a machine check, the enclave will be disabled so that it
> couldn't be entered again. Killing other processes with the same enclave
> mapped would perhaps be overkill, but they are going to find that the
> enclave is "dead" next time they try to use it. Thanks for Jarkko's head
> up and Tony's clarification on this point.
> 
> Our intension is to provide additional info so that the application has
> more choices. Current behavior looks gently, and we don't want to change
> it.
> 
> Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>

I honestly have zero idea what this patch is doing.
