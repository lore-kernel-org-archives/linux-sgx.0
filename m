Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23548C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 21:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352322AbiD1Vcv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiD1Vcs (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 17:32:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3152B888E3
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 14:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651181371; x=1682717371;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gu2GLS5HGxQ6EC+2b1y4Pm0wt5RU/cdL1sfdYasV4pA=;
  b=Hiryz3z6jzEHhAoflZvOjvlnSciy00fciyZ+RNbUScDqOtUu4SEHHTOz
   pTR9iBSM1v3PnA7Jy5+tb5OAKh3I7RHAMictC3/Gsci9En92NOBDClLWC
   l09FLVryEIllBf7mpk8LPi0xrw1nKYnPGw7bUt+8xGdWABvKWuJgxYnWY
   Epg5S5VfQCOo1qTbx8lRO0i8oS7Qo6JAJB3I6Nmwm1DqydB6EtH/nE/Wy
   tfcLofXG4lNYPBE7V0Mgu5TEvku5GPApzS+7Bi5dhe4eYx7VYIfdZZAcS
   a6cOZQB0NxS4Agtf9/oQx/Jh3P8hN/ZIwNDAEWO3TZV+0mGnAFECUZptb
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266244994"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266244994"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:29:30 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581651811"
Received: from mpoursae-mobl2.amr.corp.intel.com (HELO [10.212.0.84]) ([10.212.0.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 14:29:29 -0700
Message-ID: <883a217d-2459-6da8-3199-7a99c973cbf0@intel.com>
Date:   Thu, 28 Apr 2022 14:29:45 -0700
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cover.1651171455.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/28/22 13:11, Reinette Chatre wrote:
> ELDU returned 1073741837 (0x4000000d)

BTW, what does that decode to exactly?
