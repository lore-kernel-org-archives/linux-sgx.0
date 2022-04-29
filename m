Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1658DC433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Apr 2022 19:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347079AbiD2Tsn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Apr 2022 15:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiD2Tsm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 29 Apr 2022 15:48:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112FB7378C
        for <linux-sgx@vger.kernel.org>; Fri, 29 Apr 2022 12:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651261522; x=1682797522;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=R1yJkVlZovd5UQ4AFrnVlaW2MVEyeJfpaC1CmnxGuTI=;
  b=IcSpk72y3XMvy47wKW6MEbrJonA+xtg/ghdpuR49eK4hYVmcURxXVNhA
   78qzmU+WTAXYkj0MDRhGe8J6bCoDgKUQBbFXjwYz1LY0I7xfbnt3O14sj
   UF1YRPQ3V4DdEAyE8PImZ+xXHsIFadjRl/hbezGvLYoRGHwG5YV/pJLkO
   TaVribb1vTek53QamcuP9DbLZmQ8g1UjjxMIajUIQlS8EtbX+lARTTtLS
   dagNO7m9M+/2eiPqQzy5rzTv1tLPpxfKge8qqFwre8btUOWT+rpC9hw3F
   9X6F4YfXpAJrLnHMd0IwpLuZ5iO+f4JDejQURN8hGW5g4SsLFcplufFrI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="291929128"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="diff'?scan'208";a="291929128"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 12:45:21 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="diff'?scan'208";a="582359197"
Received: from jinggu-mobl1.amr.corp.intel.com (HELO [10.212.30.227]) ([10.212.30.227])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 12:45:20 -0700
Content-Type: multipart/mixed; boundary="------------lwOXLJuLQBCaTwvmNfHz8vye"
Message-ID: <faaaf70d-22b7-eaa5-4623-bbdf1012827a@intel.com>
Date:   Fri, 29 Apr 2022 12:45:37 -0700
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
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <825cee74-6581-1f3b-0a64-9480d6d4a8b8@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This is a multi-part message in MIME format.
--------------lwOXLJuLQBCaTwvmNfHz8vye
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/29/22 11:50, Reinette Chatre wrote:
> I am not familiar with this area - is the PFN expected to be consistent? Do
> you perhaps have an idea why the PFN of the PCMD page may have changed? This
> is running with this series applied so the ELDU flow would do a lookup of the
> PCMD page and not attempt to allocate a new one.

First of all, cool!  This is really good progress!

It's possible for the PCMD shmem page to be swapped out and swapped back
in.  The pfn would be likely to change in that case.  But, that seems
highly unlikely in that short of a period of time.

I'd dump out two more things:

First, dump out page_pcmd_off, just like you're doing with page_index in
case page_pcmd_off itself is getting botched.  I looked but couldn't
find anything obvious.

Second, dump out the pfn in sgx_encl_truncate_backing_page().  It's
possible that something is getting overly-aggressive and zapping the
PCMD page too early.  That would be easy to explain with that PCMD
locking issue you discovered.  But, your patch should have fixed that issue.

For debugging, could you double-check that the PCMD page *is* empty
around sgx_encl_truncate_backing_page()?  If there's a race here you can
also enlarge the race window by adding an msleep() or a spin loop
somewhere after the memchr_inv().

You could also hold an extra reference on the PCMD page, maybe something
like the attached patch.  That will let you inspect the actual page
after it is *actually* truncated.  There should never be data in the
page there.
--------------lwOXLJuLQBCaTwvmNfHz8vye
Content-Type: text/x-patch; charset=UTF-8; name="pcmd.diff"
Content-Disposition: attachment; filename="pcmd.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2wuYyBiL2FyY2gveDg2
L2tlcm5lbC9jcHUvc2d4L2VuY2wuYwppbmRleCA3YzYzYTE5MTFmYWUuLjMwOWZmYWU0M2Uw
ZiAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9zZ3gvZW5jbC5jCisrKyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvc2d4L2VuY2wuYwpAQCAtOTEsMTUgKzkxLDIwIEBAIHN0YXRp
YyBpbnQgX19zZ3hfZW5jbF9lbGR1KHN0cnVjdCBzZ3hfZW5jbF9wYWdlICplbmNsX3BhZ2Us
CiAJICovCiAJcGNtZF9wYWdlX2VtcHR5ID0gIW1lbWNocl9pbnYocGNtZF9wYWdlLCAwLCBQ
QUdFX1NJWkUpOwogCi0Ja3VubWFwX2F0b21pYyhwY21kX3BhZ2UpOwogCWt1bm1hcF9hdG9t
aWMoKHZvaWQgKikodW5zaWduZWQgbG9uZylwZ2luZm8uY29udGVudHMpOwogCisJZ2V0X3Bh
Z2UoYi5wY21kKTsKIAlzZ3hfZW5jbF9wdXRfYmFja2luZygmYiwgZmFsc2UpOwogCiAJc2d4
X2VuY2xfdHJ1bmNhdGVfYmFja2luZ19wYWdlKGVuY2wsIHBhZ2VfaW5kZXgpOwogCi0JaWYg
KHBjbWRfcGFnZV9lbXB0eSkKKwlpZiAocGNtZF9wYWdlX2VtcHR5KSB7CiAJCXNneF9lbmNs
X3RydW5jYXRlX2JhY2tpbmdfcGFnZShlbmNsLCBQRk5fRE9XTihwYWdlX3BjbWRfb2ZmKSk7
CisJCVdBUk5fT04obWVtY2hyX2ludihwY21kX3BhZ2UsIDAsIFBBR0VfU0laRSk7CisJfQor
CisJa3VubWFwX2F0b21pYyhwY21kX3BhZ2UpOworCXB1dF9wYWdlKHBjbWRfcGFnZSk7CiAK
IAlyZXR1cm4gcmV0OwogfQo=

--------------lwOXLJuLQBCaTwvmNfHz8vye--
