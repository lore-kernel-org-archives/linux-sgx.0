Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1730C433F5
	for <linux-sgx@archiver.kernel.org>; Thu,  5 May 2022 00:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbiEEAEv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 4 May 2022 20:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379901AbiEDXyQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 4 May 2022 19:54:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B64473B9
        for <linux-sgx@vger.kernel.org>; Wed,  4 May 2022 16:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651708236; x=1683244236;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PFXamuZdPBbzEHBQ9pGiUhI2SNKH5j3NOHVfozDe+OM=;
  b=bu1fcOek04yf4W1bs7OQrn3fXv1k0c4uGly9SyaOs8zDG5Bn+XC0rq+z
   l4Y+wZMhV1qpsP18CVuuzc9esa0IFyqX0C7MT5EVLLt7RWH1YDiCOAbPZ
   PsbFTAUbA4axJUTnWXg/Lz+HIrjE/Vq8VgKPbQt3StPnzMEkz95b2p0mW
   afq5nP479X9UTmHG6v0uTML3Fx/h5xBQ/yYuMYyS2Jz6OCNped1jDETNs
   hXXKqKJeKD3WFu+0GnQhMR1u2mWUA34RGsw61YWW77xEbsvycH6kEjLtJ
   nLtuCgyVzFqmYXxekTmfOB4bZ4MM1jgr2TEoLEx9eEDUR/crS7Pc5lcBC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="330920908"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="330920908"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 16:50:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="562967944"
Received: from jrhamric-mobl.amr.corp.intel.com (HELO [10.212.121.177]) ([10.212.121.177])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 16:50:34 -0700
Message-ID: <fd752d77-9f33-9618-36c1-66dee6c2e93c@intel.com>
Date:   Wed, 4 May 2022 16:50:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
Content-Language: en-US
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
References: <cover.1651171455.git.reinette.chatre@intel.com>
 <fd4a9b83-f8da-5fb0-c722-79eb91b2fc30@intel.com>
 <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
 <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
 <feedd67f-4b50-aac1-16de-a3ffce9208c6@intel.com>
 <d7a3929d-3b49-dc77-8f6c-0308fbcf3948@intel.com>
 <f6e64c4f-8539-b7e7-7890-a4b1acc073fe@intel.com>
 <c057af3d-b7fb-34cd-0d75-989fca0e67fe@intel.com>
 <d4b52482-2dd0-d5f1-bda9-e1d97883298d@intel.com>
 <705c7c6a-3618-2d74-115c-68347b8aa8e6@intel.com>
 <468848d0-ad58-8da0-dd39-b9604d458cdf@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <468848d0-ad58-8da0-dd39-b9604d458cdf@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/4/22 16:36, Reinette Chatre wrote:
> The page fault handler cannot check for SGX_ENCL_PAGE_BEING_RECLAIMED
> until the reclaimer releases the mutex.

Ahh, got it now.  I thought the mutex wasn't held on the reclaimer side.
 Thanks for the refresher.

>> One other thing.  The role of encl->lock here is very important.
>> Without it, two concurrent page faults could do their individual
>> memset(), each see !pcmd_page_empty, then decline to truncate the page.
> 
> Your argument is not clear to me. Yes, this would be an issue (and
> that will not be the only issue) if the enclave mutex is not held
> by the page fault handler ... but the enclave mutex _is_ held by the
> page fault handler.

It would just be nice to clearly state the locking logic in the eventual
changelog.

>> Also, given the challenges here, I do think we should check the
>> pcmd_page after truncate to ensure it is still all zero's.
> 
> Could you please elaborate the challenges? I do not think it would
> help the issue at hand at all to add a check since this is done with
> the mutex held while the reclaimer has a reference to the page but no
> mutex ... as long as the page fault handler has that mutex it can write
> and check the PCMD page all it want, the new changes would occur to the
> PCMD page when it (the page fault handler) releases the mutex and the
> reclaimer attempts to use the page it has a reference to.

I'm just asking for a debugging check that looks at the page *after* is
has been truncated to ensure it is zero, in case another bug creeps in here.
