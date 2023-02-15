Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15D9C636CC
	for <linux-sgx@archiver.kernel.org>; Wed, 15 Feb 2023 04:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjBOEnD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Feb 2023 23:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbjBOEnC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 14 Feb 2023 23:43:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE1625B82
        for <linux-sgx@vger.kernel.org>; Tue, 14 Feb 2023 20:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676436179; x=1707972179;
  h=to:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=AZiZTCnvE7xUvCCwye3RFRUIXnsOpuwOj8ldXHTzo84=;
  b=BfW/W+YsrdQsj9/EScnBpHskE1UjmHfNbrtVwtreMlGvRmWPdNx0pU98
   KMuw5bv6wJuaftVj8DpQ7feZ4LcpTnOCZ+/CGHmuHOUtdunh8opshyvv+
   +qf+NJvuINlJBjpppGSSPihk6ee8BLeA/W5mZHTJ0jFlG1cgNIvVj/lcZ
   KS0nRsFSejwJvMp/BzYQ1vRQ7nS5yML6fQzcev0jfmAlWwZuWpKhxBekB
   nhLQA3eOZQ9gshE+FS2gYtRyuKHAkGiW4TDfl0o2Yryf5Sb8JH8giJSu4
   FsQ1X0Y1PVXW5gksrsD2WxH3lKKuQT72ggIeFJw0jN/amHuapBLnytwmj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="314995627"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="314995627"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 20:42:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="701888925"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="701888925"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.212.233.201])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 14 Feb 2023 20:42:58 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "Dhanraj, Vijay" <vijay.dhanraj@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "Huang, Kai" <kai.huang@intel.com>
Subject: Re: [RFC PATCH v4 4/4] selftests/sgx: Add test for madvise(...,
 WILLNEED)
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
 <20230128045529.15749-2-haitao.huang@linux.intel.com>
 <20230128045529.15749-3-haitao.huang@linux.intel.com>
 <20230128045529.15749-4-haitao.huang@linux.intel.com>
 <20230128045529.15749-5-haitao.huang@linux.intel.com>
 <66db7859f696743b036c9dba3d040d196477984d.camel@intel.com>
Date:   Tue, 14 Feb 2023 22:42:57 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.10d4pvguwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <66db7859f696743b036c9dba3d040d196477984d.camel@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 14 Feb 2023 20:38:29 -0600, Huang, Kai <kai.huang@intel.com> wrote:

> On Fri, 2023-01-27 at 20:55 -0800, Haitao Huang wrote:
>> +/*
>> + * Compare performance with and without madvise call before EACCEPT'ing
>> + * different size of regions.
>> + */
>> +TEST_F_TIMEOUT(enclave, augment_via_madvise, TIMEOUT_DEFAULT)
>> +{
>>
> [...]
>
>> +
>> +	for (i = 0; i < self->encl.nr_segments; i++) {
>> +		struct encl_segment *seg = &self->encl.segment_tbl[i];
>> +
>> +		total_size += seg->size;
>> +	}
>> +
>> +	for (i = 1; i < 52 && advise_size < max_advise_size; i++) {
>> +		addr = mmap((void *)self->encl.encl_base + total_size, advise_size,
>> +			    PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED,
>> +					self->encl.fd, 0);
>
> I see the problem now.  Here 'pgoff' is always 0.  I think this is wrong.
>
> Shouldn't you use the actual offset relative to the file as pgoff, which  
> is
> 	
> 	total_size >> PAGE_SHIFT
>
> ?
>
But that will be inconsistent with current usage. We have been using zero  
offset always including these self tests. The offset is also redundant in  
this case because it is totally defined by the address for a given enclave  
fd.

>
> [...]
>
>> +	    munmap(addr, advise_size);
>
> Incorrect indent here?
>
> Perhaps you should use checkpatch.pl?
>

hmm, I did run it:
  scripts/checkpatch.pl --strict  
advise_patch_RFC_v4/v4-0004-selftests-sgx-Add-test-for-madvise-.-WILLNEED.patch
total: 0 errors, 0 warnings, 0 checks, 179 lines checked

Will fix.

Thanks
Haitao
