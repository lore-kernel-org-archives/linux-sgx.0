Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7CDECAAD4
	for <linux-sgx@archiver.kernel.org>; Wed, 31 Aug 2022 18:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiHaSmR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 14:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiHaSmF (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 14:42:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B3A5FA2
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 11:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661970293; x=1693506293;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GxihznNswtvhbdVpryhBAdAIUpTuuql68nMdrRswAkA=;
  b=k1DRvbOenM8/h3SpqnS/Voq/65VOOiiSlRZ9P0Ezc/GqgEwyjBYLTHgp
   Wv3gljivlpZQjklRXuuK0Hr0TB6xt6kl0fPfT2hEqg+CA/b55OyT3N9eD
   78nE0S0Cg62ih66rwdLj8mbKRej5o51z+H+LK0WkrMYM4SuXY7uW7nDrc
   GrgZ6VpwHAIyHAptVSBlGgkHBr5tnl+mdjatXHgpo8OEA0Ywqy4PBsEKo
   bKNuxhJqFFVU2YedlGgvvby0Thhzm4dJzofTMKD9eU5E8jkqijKJbFBme
   41ee0/SR/0CJucmFi9acrRpm1y688e/T9eNKjXj3cQSY6ib7fuiaKsxBg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="357232810"
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="357232810"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 11:24:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,278,1654585200"; 
   d="scan'208";a="612187784"
Received: from nkrobins-mobl2.amr.corp.intel.com (HELO [10.212.220.19]) ([10.212.220.19])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 11:24:52 -0700
Message-ID: <37c35ede-b453-0d62-cee6-802ef98ae1ff@intel.com>
Date:   Wed, 31 Aug 2022 11:24:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/6] x86/sgx: A collection of tests and fixes
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <20220831173829.126661-1-jarkko@kernel.org>
 <cfa17cdd-796e-be75-d371-9dea9c2876e8@intel.com>
 <Yw+kZdGBYEQARYIm@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Yw+kZdGBYEQARYIm@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 8/31/22 11:11, Jarkko Sakkinen wrote:
> On Wed, Aug 31, 2022 at 10:43:05AM -0700, Dave Hansen wrote:
>> Jarkko,
>>
>> What is your expectations of this series?  There's nothing in the cover
>> letter.
>>
>> Do you think all of this is urgent material that needs to go to Linus
>> for 6.0?  Or is it all 6.1 material?
> Hmm... Let me think.
> 
> I would pick exactly 2/6 and 3/6 and postpone rest for 6.1.
> 
> 2/6 is IMHO critical fix and 3/6 is fix for a commit that
> is part of 6.0.

That's really great context, thanks!  Next time, could you please
include that in your cover letter(s) and split the patches up between
urgent non-urgent bits?
