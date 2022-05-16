Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CB4C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 16 May 2022 14:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiEPOOV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 May 2022 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiEPOOU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 May 2022 10:14:20 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E093A728
        for <linux-sgx@vger.kernel.org>; Mon, 16 May 2022 07:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652710460; x=1684246460;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bfpaxPLwVSULJ6hz3oCszh/Yg0sgRjOCni+lW8g/jhI=;
  b=fY74mlowcUFo3MVsCvQABxw6Eq8fNqm31fYcTLcfjnNtZ8B7tbZ02AA1
   7ktKupi+a6uH68oep3Ub4Mh+Ua9GdPfIJtD5UqPMSzsQwTHRDaRaxR9Ix
   CWlvbje/DhCMdv2jCgLKKjGzabsu3JJM6dmgPZTp5oMH/UHRCYaImZ3ok
   yDsvRWQbL+PWKg6EIBivADX0PuXfywmd6cyFDcSq5w/iWxMXRlHKoZrvE
   bYpNMBuHh1jrsD1yT6iNtL7HqfOdXbdc+qwQT9IkFSkgIfpVGANvhk0ud
   opjSfGDH9vB0TjoKak183X5F9AmtshwyIZlqF0xWEigsuSpcofIzFgGNY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="251358513"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="251358513"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:13:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="555266899"
Received: from dmjacob-mobl.amr.corp.intel.com (HELO [10.212.130.28]) ([10.212.130.28])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 07:13:43 -0700
Message-ID: <c148ab48-1b70-6e20-5742-b0b2dc014dc3@intel.com>
Date:   Mon, 16 May 2022 07:13:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: VMA's not getting merged
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org
Cc:     "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        reinette.chatre@intel.com
References: <884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/14/22 18:20, Jarkko Sakkinen wrote:
> Looks like VMA's do not get merged properly:
...
> 7f8f0800b000-7f8f08014000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 7f8f08014000-7f8f08025000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 7f8f08025000-7f8f08046000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 7f8f08046000-7f8f0804a000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 7f8f0804a000-7f8f0804b000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 7f8f0804b000-7f8f0804c000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 7f8f0804c000-7f8f0804d000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 7f8f0804d000-7f8f0804e000 rw-s 00000000 00:05 84                         /dev/sgx_enclave

I remember some issue with VM_IO VMAs not getting merged, but I don't
remember how we fixed or addressed it.

Seems like something we can and should fix, though.
