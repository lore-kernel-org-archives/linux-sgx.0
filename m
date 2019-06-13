Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E373BC31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 18:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD5BF20645
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 18:00:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="BEumBVae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfFMSAi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 14:00:38 -0400
Received: from uhil19pa12.eemsg.mail.mil ([214.24.21.85]:45087 "EHLO
        uhil19pa12.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfFMSAi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Jun 2019 14:00:38 -0400
X-EEMSG-check-017: 419600571|UHIL19PA12_EEMSG_MP10.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by uhil19pa12.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 13 Jun 2019 18:00:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1560448833; x=1591984833;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=FiAqWJVW5zWXQa4rT+swu1Q/r9kcZzx+fSWkhK1DIt0=;
  b=BEumBVae8dZ5k5kWarStyTrrWJfbVJnv7d7ONVXfArGWZxc7GL5yM2YW
   J4bl/6WvYSusoS8ySCbF4fnGaAJRKpSl84lUMY4zVU6Xdgxlcm+upRo23
   l3xtcv3bxUsCYU84s/GBnEKJukq9LtWASzdDyB9dBZvUKOiiYDxHjaiqJ
   hpH7y/930eDOTwmv8Ikilb2jxqP/LUPmSC2ZhkUmoJTPm47CLbXrJgvrR
   ggCpTtjWEsSh8Diwm0zZyKMS40f+TOogVDZMaJ5vrt71924T0bRCkQtIr
   pHKKyBLMvUI1aIYsvfCghxiiA0inz7YelXv4uW++B/m39kmWC+vkumnwG
   g==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557187200"; 
   d="scan'208";a="28942853"
IronPort-PHdr: =?us-ascii?q?9a23=3AcAmvaxXpxhU0HppVbkTbVndJl9bV8LGtZVwlr6?=
 =?us-ascii?q?E/grcLSJyIuqrYZhOBv6dThVPEFb/W9+hDw7KP9fy5ACpZvMfK6SlcOLV3FD?=
 =?us-ascii?q?Y9wf0MmAIhBMPXQWbaF9XNKxIAIcJZSVV+9Gu6O0UGUOz3ZlnVv2HgpWVKQk?=
 =?us-ascii?q?a3OgV6PPn6FZDPhMqrye+y54fTYwJVjzahfL9+Nhq7oRjMusUMnIdvKqI8xh?=
 =?us-ascii?q?TUrndVeuld2H9lK0+Ukxvg/Mm74YRt8z5Xu/Iv9s5AVbv1cqElRrFGDzooLn?=
 =?us-ascii?q?446tTzuRbMUQWA6H0cUn4LkhVTGAjK8Av6XpbqvSTksOd2xTSXMtf3TbAwXj?=
 =?us-ascii?q?Si8rtrRRr1gyoJKzI17GfagdFrgalFvByuuQBww4/MYIGUKvV+eL/dfcgHTm?=
 =?us-ascii?q?ZFR8pdSjBNDp+5Y4YJAeUBJ+JYpJTjqVUIoxW1GA2gCPrhxzJMg3P727Ax3e?=
 =?us-ascii?q?Y8HgHcxAEuAswAsHrUotv2OqkdX++6w6vUwjvMdP5WxTTw5ZLUfhw9r/yBX7?=
 =?us-ascii?q?R9etfRx0k1EAPFi02dp5H5PzyLzuQNs3aU7+x9Xuyyjm4osQVxojyxycYsl4?=
 =?us-ascii?q?LEgZkVxU3f9Shi3IY0JcG3SE58YdK+FptQrDuVO5F5QsMlXWFloSA3waAFt5?=
 =?us-ascii?q?6jZCUG1ZsqyhHFZ/GHboSE+AzvWemPLTtimX5ofq+0iQyo/ki60OL8U9G50F?=
 =?us-ascii?q?NNriVYjNbBrmsN1xnP6sifTft941uh1S6P1w/N7uFEJlg5lbbBJJ47w74wi4?=
 =?us-ascii?q?ETvV7fHi72hEr2jKiWel8i+ue08OTofq/qppqdN49wkg3+M6IuldKjAekgLw?=
 =?us-ascii?q?QDUGeW9f682bH+50H1XrpHguMsnqXEqJzaIN4Upq+9Aw9byIYj7BO/Ai+90N?=
 =?us-ascii?q?sFhnkKN05FeRKbgIjpPFHCOvb4DeyljFi2nzdrwO7GMqX7AprRNnjDjKvhfb?=
 =?us-ascii?q?Fl5kFA1gU80Mpf55NIBb0bL/PzW0nxtNPDAx84NQy03/joCNFn2owCXmKPB7?=
 =?us-ascii?q?eTMLnOvl+Q+uIvP+6MaZcRuDb8Lfgl+vHvgWYimVADYaapwIEXaHGkHvVmOk?=
 =?us-ascii?q?mZZH3sjcocEWcOoAUzV/LqiFKcXj5JfXqyXLwz5is9CI24CYfPXIetgKaO3C?=
 =?us-ascii?q?2jBJ1ZenhGCkyQEXfvb4iEQOkDaCaTIs9njzwFWqOsS5Eu1R6wrg/20blnIf?=
 =?us-ascii?q?TO+i0eq53j0MJ55+rJlRE97TZ0FdiS03mRT2FomWMFXzs23KF5oUxgxVaPyK?=
 =?us-ascii?q?t4jOJCFdxV+fxJVhw3NYDTz+NkEdD+QAHBccmTSFagXNqmBSs9TtUrw98Be0?=
 =?us-ascii?q?x9Acmtjgjf3yq2BL8Yj7iLBJ0y8qLB0Hn9Pt19y3nJ1aQ6kVkmTdVANXe8iq?=
 =?us-ascii?q?586QfTHYjJnFudl6qwcqQcxiHN/n+ZzWWSpEFYTBJwUaLdUHAdfETWt9f55k?=
 =?us-ascii?q?DFT7O0ErQoKAhByc2DKqtMdNLpi05LRPPiONTYfmKwlH28BReOxrOQcoXqf3?=
 =?us-ascii?q?8R0znaCEgBiwoT52qJNRAiBie9pGLTFDhuFU/zY0Pr6uR+q220TlUyzw6Ua0?=
 =?us-ascii?q?1tzb21+gQahfaEUfMcwqoEuDs9qzVzBFu93dfWC92apwp7faVcesgw4FFd2m?=
 =?us-ascii?q?LcqQN9P4asL6d4hl4Raw53pV/h1w1rCoVclsgntGgqwxRoKaKXzlxMbDOY0o?=
 =?us-ascii?q?r0Or3TKmjy+gqjZLLR2lHbyNyW4LsA6Owkq1X/uwGkDlIi/G9609lRyHac/o?=
 =?us-ascii?q?/FDBcWUZ7oV0Y38B96p6vEbSUn+4zU0nhsO7GusjDew9IpGPclyhG4cthBKK?=
 =?us-ascii?q?OLDhXyE8wBB8W1MOwlgUKpbhMfPOBK8K47Jd+peOWc1K6sJuZgkyqsjX5b74?=
 =?us-ascii?q?BlzkKM6y18R/bK35kb3/GY3hGHVzDngVevtcD3g5xEaisUHmq+xinoHpJeZq?=
 =?us-ascii?q?p3fYwTE2ehP9W3xslih57qQ3NX6USsB00Y18OzeRqddVr93RZO2kQRunGnmC?=
 =?us-ascii?q?24zyBqnDEttKaQwCvOw+H6fhodJmFLXHVijUvrIYWsk9AaU0yobgcymRuh5E?=
 =?us-ascii?q?b6wbVbpLhlL2nUR0dIfif3I3t/XaSurrCCedJA6Is0sSVLV+SxeUyaSrnnox?=
 =?us-ascii?q?sEySzjG3ZRxCsgejGuu5X5mQF6iW2EIHZ9q3rZZMdwygrF69zARP5R2TwGSD?=
 =?us-ascii?q?N/iTnNCVi2J8Op8smMl5ffruC+UHqsWYdQcSnzyIONry+75WxsAR2ikPG/g9?=
 =?us-ascii?q?PnEQ8n0S/9ytZlTznIrBf7Yontzai6NvhnfkZwDl/m98V6Ap1+kpc3hJwI33?=
 =?us-ascii?q?gahpKV/WACkWjpN9VWwrj+Y2QQSj4L2dHV/BLp11FkLnKM34j5TGmSwtN9Z9?=
 =?us-ascii?q?mmZWMbwjo978VWB6iI9rNEmS91oke9rQ/Ke/hygCoSyfs0534Gme0GpA0tzi?=
 =?us-ascii?q?CFCLAIAUZYJTDslwiP792mt6VYenyvcbeu20Zkh9+gDLaCohxaWHvie5ciGz?=
 =?us-ascii?q?Nw4dt7MF7WzHLz7YTkcsHKbd0Prh2UjwvAj+9NJZIqlvoFnypmNXj+vXI/1+?=
 =?us-ascii?q?46jAVi3JCgs4iCKmVt5rm0Ah9eNj3pecwT/ivhgrpZnsaTx4qvBIluGi0XXJ?=
 =?us-ascii?q?v0SvKlCDISuu7mNwaSCjI8rW2XGbrCHQCF7kdmoGnCE5GtN3GLOnYZyc9uSw?=
 =?us-ascii?q?WaJExamAoURik1noYlFgC2w8zsaF125jYM6V7iqxtNyvhkNwL/UmjBugendj?=
 =?us-ascii?q?c0R4aZLBpV6QFP/EPVMc2Y7uJuECBU5JyhrAqRKmOFYwREF30GWkuBB1r7JL?=
 =?us-ascii?q?mh+cHA8/SEBuq5N/bOYq+Bqe1EW/eT25KgyItm/zCXO8WOOHliE+M02k5ZUX?=
 =?us-ascii?q?9lHMTZni0FSzYLmCLVc86buBC89zVsocCn6/nkQgbv5YqRBLtUMthj4Q25jr?=
 =?us-ascii?q?mbPe6KmCl5MSpY1o8LxXLQyrgf20USiyF1ejmvFrQAri7NTL7Kmq9WFx4bbz?=
 =?us-ascii?q?18NNdU764m2QlNI8HbgMvv1rFklv41F0tFVVv5l8Gqf8MKInuxNFPaBEmRMr?=
 =?us-ascii?q?SGKibGw8DxYaOgV7JQiP9YuAG3uTaeC0XjJCiMlyH1VxCzNuFBlDubPB1At4?=
 =?us-ascii?q?G7bhZtC3bsTMn9Zx20N993ijI2wbkqiX/QKWEcNj18eVtXrrKM9SNYnul/G2?=
 =?us-ascii?q?tZ43trLOmEnyKZ7+jCJZYTq/dkHj54l/hd4Hsh1bRV9j1EROdulSvTqN5uv0?=
 =?us-ascii?q?+pku2VxjV7VxpOry5BhJiXskV6JaXZ6p5AVG7c/BIN7GWQDxUKp8N/BtL0oa?=
 =?us-ascii?q?xQ1sLPlKPvJzhe6d3Z5socB87IKM2ZNHotKwbmGDnRDFhNcTn+f1HegUMZ2N?=
 =?us-ascii?q?qf+meUpdJy/pPhlIAPQflLVVo6PvIcFklhWtcFJcEzFnkgkLiGnIsT6HGjth?=
 =?us-ascii?q?jNVYBfuZzaUv+6H/riMnCagKNCah9Oxqn3Z8xHMoz9xlwncVRxgZ7LB1uVWN?=
 =?us-ascii?q?dBvylsRhE7rV8L83VkSGA3nUX/ZVXpqDUIGPq1mAMmohVxbP5r9zr25VozYF?=
 =?us-ascii?q?3Qq2F4xFI8ndTjnCC5bjH8NuGzUJtQBi6ysFI+ZNezCQJ0axCi2E9pLjHJQ5?=
 =?us-ascii?q?pPgLZ6M2NmkgnRvd1IA/EWBflAYRkN1bSUau8u3FB0tCqq3wlE6PHDBJ8kkx?=
 =?us-ascii?q?ElJ9rk5XZB3R9zKcU6NYTOK6dTiFtdnKSDummvzO97iFsaJkAQ4CaJdz4gpk?=
 =?us-ascii?q?MFLP8lKjCu8+gq7haNzWhtYm8JAsE2r+pq+0V1AOGJyybtwvYXMUyqH/COJK?=
 =?us-ascii?q?Oe/W7bnIiHRU1mhRBArFVM4bUjiZRrSEGTTU16ieLKRhk=3D?=
X-IPAS-Result: =?us-ascii?q?A2CpCAAIjgJd/wHyM5BlHAEBAQQBAQcEAQGBZYFiBSqBO?=
 =?us-ascii?q?wEyKIQWknZMAQIBAQEGgRAlfohTkQsJAQEBAQEBAQEBNAECAQGEQAKCSSM4E?=
 =?us-ascii?q?wEDAQEBBAEBAQEDAQFsKII6KQGCZgEBAQEDIwQLAQVBEAsVAQICAiMDAgJGE?=
 =?us-ascii?q?QYBDAYCAQGCXz+BdxSrJ34zhAYBgUCDJIFGgQwoi10XeIEHgREnDIIqNT6HT?=
 =?us-ascii?q?oJYBItDDxKCIIdDlAUJghKCG5ErBhuCJosKiXyNG4ErlzUhgVgrCAIYCCEPO?=
 =?us-ascii?q?4JsghsXjWkBUiMDMIEGAQGQLQEB?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 13 Jun 2019 18:00:32 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x5DI0UL0024743;
        Thu, 13 Jun 2019 14:00:30 -0400
Subject: Re: [RFC PATCH v1 2/3] LSM/x86/sgx: Implement SGX specific hooks in
 SELinux
To:     "Xing, Cedric" <cedric.xing@intel.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Cc:     "jarkko.sakkinen@linux.intel.com" <jarkko.sakkinen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "pmccallum@redhat.com" <pmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
References: <cover.1560131039.git.cedric.xing@intel.com>
 <a382d46f66756e13929ca9244479dd9f689c470e.1560131039.git.cedric.xing@intel.com>
 <b6f099cd-c0eb-d5cf-847d-27a15ac5ceaf@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F65502A85@ORSMSX116.amr.corp.intel.com>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <b7f3decf-b1d2-01b1-6294-ccf9ba2d5df4@tycho.nsa.gov>
Date:   Thu, 13 Jun 2019 14:00:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F65502A85@ORSMSX116.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/11/19 6:55 PM, Xing, Cedric wrote:
>> From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
>> owner@vger.kernel.org] On Behalf Of Stephen Smalley
>> Sent: Tuesday, June 11, 2019 6:40 AM
>>
>>>
>>> +#ifdef CONFIG_INTEL_SGX
>>> +	rc = sgxsec_mprotect(vma, prot);
>>> +	if (rc <= 0)
>>> +		return rc;
>>
>> Why are you skipping the file_map_prot_check() call when rc == 0?
>> What would SELinux check if you didn't do so -
>> FILE__READ|FILE__WRITE|FILE__EXECUTE to /dev/sgx/enclave?  Is it a
>> problem to let SELinux proceed with that check?
> 
> We can continue the check. But in practice, all FILE__{READ|WRITE|EXECUTE} are needed for every enclave, then what's the point of checking them? FILE__EXECMOD may be the only flag that has a meaning, but it's kind of redundant because sigstruct file was checked against that already.

I don't believe FILE__EXECMOD will be checked since it is a shared file 
mapping.  We'll check at least FILE__READ and FILE__WRITE anyway upon 
open(), and possibly FILE__EXECUTE upon mmap() unless that is never 
PROT_EXEC.  We want the policy to accurately reflect the operations of 
the system, even when an operation "must" be allowed, and even here this 
only needs to be allowed to processes authorized as enclave loaders, not 
to all processes.

I don't think there are other examples where we skip a SELinux check 
like this.  If we were to do so here, we would at least need a comment 
explaining that it was intentional and why.  The risk would be that 
future checking added into file_map_prot_check() would be unwittingly 
bypassed for these mappings.  A warning there would also be advisable if 
we skip it for these mappings.

> 
>>> +static int selinux_enclave_load(struct file *encl, unsigned long addr,
>>> +				unsigned long size, unsigned long prot,
>>> +				struct vm_area_struct *source)
>>> +{
>>> +	if (source) {
>>> +		/**
>>> +		 * Adding page from source => EADD request
>>> +		 */
>>> +		int rc = selinux_file_mprotect(source, prot, prot);
>>> +		if (rc)
>>> +			return rc;
>>> +
>>> +		if (!(prot & VM_EXEC) &&
>>> +		    selinux_file_mprotect(source, VM_EXEC, VM_EXEC))
>>
>> I wouldn't conflate VM_EXEC with PROT_EXEC even if they happen to be
>> defined with the same values currently.  Elsewhere the kernel appears to
>> explicitly translate them ala calc_vm_prot_bits().
> 
> Thanks! I'd change them to PROT_EXEC in the next version.
> 
>>
>> Also, this will mean that we will always perform an execute check on all
>> sources, thereby triggering audit denial messages for any EADD sources
>> that are only intended to be data.  Depending on the source, this could
>> trigger PROCESS__EXECMEM or FILE__EXECMOD or FILE__EXECUTE.  In a world
>> where users often just run any denials they see through audit2allow,
>> they'll end up always allowing them all.  How can they tell whether it
>> was needed? It would be preferable if we could only trigger execute
>> checks when there is some probability that execute will be requested in
>> the future.  Alternatives would be to silence the audit of these
>> permission checks always via use of _noaudit() interfaces or to silence
>> audit of these permissions via dontaudit rules in policy, but the latter
>> would hide all denials of the permission by the process, not just those
>> triggered from security_enclave_load().  And if we silence them, then we
>> won't see them even if they were needed.
> 
> *_noaudit() is exactly what I wanted. But I couldn't find selinux_file_mprotect_noaudit()/file_has_perm_noaudit(), and I'm reluctant to duplicate code. Any suggestions?

I would have no objection to adding _noaudit() variants of these, either 
duplicating code (if sufficiently small/simple) or creating a common 
helper with a bool audit flag that gets used for both. But the larger 
issue would be to resolve how to ultimately ensure that a denial is 
audited later if the denied permission is actually requested and blocked 
via sgxsec_mprotect().

>   
>>
>>> +			prot = 0;
>>> +		else {
>>> +			prot = SGX__EXECUTE;
>>> +			if (source->vm_file &&
>>> +			    !file_has_perm(current_cred(), source->vm_file,
>>> +					   FILE__EXECMOD))
>>> +				prot |= SGX__EXECMOD;
>>
>> Similarly, this means that we will always perform a FILE__EXECMOD check
>> on all executable sources, triggering audit denial messages for any EADD
>> source that is executable but to which EXECMOD is not allowed, and again
>> the most common pattern will be that users will add EXECMOD to all
>> executable sources to avoid this.
>>
>>> +		}
>>> +		return sgxsec_eadd(encl, addr, size, prot);
>>> +	} else {
>>> +		/**
>>> +		  * Adding page from NULL => EAUG request
>>> +		  */
>>> +		return sgxsec_eaug(encl, addr, size, prot);
>>> +	}
>>> +}
>>> +
>>> +static int selinux_enclave_init(struct file *encl,
>>> +				const struct sgx_sigstruct *sigstruct,
>>> +				struct vm_area_struct *vma)
>>> +{
>>> +	int rc = 0;
>>> +
>>> +	if (!vma)
>>> +		rc = -EINVAL;
>>
>> Is it ever valid to call this hook with a NULL vma?  If not, this should
>> be handled/prevented by the caller.  If so, I'd just return -EINVAL
>> immediately here.
> 
> vma shall never be NULL. I'll update it in the next version.
> 
>>
>>> +
>>> +	if (!rc && !(vma->vm_flags & VM_EXEC))
>>> +		rc = selinux_file_mprotect(vma, VM_EXEC, VM_EXEC);
>>
>> I had thought we were trying to avoid overloading FILE__EXECUTE (or
>> whatever gets checked here, e.g. could be PROCESS__EXECMEM or
>> FILE__EXECMOD) on the sigstruct file, since the caller isn't truly
>> executing code from it.
> 
> Agreed. Another problem with FILE__EXECMOD on the sigstruct file is that user code would then be allowed to modify SIGSTRUCT at will, which effectively wipes out the protection provided by FILE__EXECUTE.
> 
>>
>> I'd define new ENCLAVE__* permissions, including an up-front
>> ENCLAVE__INIT permission that governs whether the sigstruct file can be
>> used at all irrespective of memory protections.
> 
> Agreed.
> 
>>
>> Then you can also have ENCLAVE__EXECUTE, ENCLAVE__EXECMEM,
>> ENCLAVE__EXECMOD for the execute-related checks.  Or you can use the
>> /dev/sgx/enclave inode as the target for the execute checks and just
>> reuse the file permissions there.
> 
> Now we've got 2 options - 1) New ENCLAVE__* flags on sigstruct file or 2) FILE__* on /dev/sgx/enclave. Which one do you think makes more sense?
> 
> ENCLAVE__EXECMEM seems to offer finer granularity (than PROCESS__EXECMEM) but I wonder if it'd have any real use in practice.

Defining a separate ENCLAVE__EXECUTE and using it here for the sigstruct 
file would avoid any ambiguity with the FILE__EXECUTE check to the 
/dev/sgx/enclave inode that might occur upon mmap() or mprotect().  A 
separate ENCLAVE__EXECMEM would enable allowing WX within the enclave 
while denying it in the host application or vice versa, which could be a 
good thing for security, particularly if SGX2 largely ends up always 
wanting WX.

> 
>>> +int sgxsec_mprotect(struct vm_area_struct *vma, size_t prot) {
>>> +	struct enclave_sec *esec;
>>> +	int rc;
>>> +
>>> +	if (!vma->vm_file || !(esec = __esec(selinux_file(vma->vm_file))))
>> {
>>> +		/* Positive return value indicates non-enclave VMA */
>>> +		return 1;
>>> +	}
>>> +
>>> +	down_read(&esec->sem);
>>> +	rc = enclave_mprotect(&esec->regions, vma->vm_start, vma->vm_end,
>>> +prot);
>>
>> Why is it safe for this to only use down_read()? enclave_mprotect() can
>> call enclave_prot_set_cb() which modifies the list?
> 
> Probably because it was too late at night when I wrote this line:-( Good catch!
> 
>>
>> I haven't looked at this code closely, but it feels like a lot of SGX-
>> specific logic embedded into SELinux that will have to be repeated or
>> reused for every security module.  Does SGX not track this state itself?
> 
> I can tell you have looked quite closely, and I truly think you for your time!
> 
> You are right that there are SGX specific stuff. More precisely, SGX enclaves don't have access to anything except memory, so there are only 3 questions that need to be answered for each enclave page: 1) whether X is allowed; 2) whether W->X is allowed and 3 whether WX is allowed. This proposal tries to cache the answers to those questions upon creation of each enclave page, meaning it involves a) figuring out the answers and b) "remember" them for every page. #b is generic, mostly captured in intel_sgx.c, and could be shared among all LSM modules; while #a is SELinux specific. I could move intel_sgx.c up one level in the directory hierarchy if that's what you'd suggest.
> 
> By "SGX", did you mean the SGX subsystem being upstreamed? It doesn’t track that state. In practice, there's no way for SGX to track it because there's no vm_ops->may_mprotect() callback. It doesn't follow the philosophy of Linux either, as mprotect() doesn't track it for regular memory. And it doesn't have a use without LSM, so I believe it makes more sense to track it inside LSM.

Yes, the SGX driver/subsystem.  I had the impression from Sean that it 
does track this kind of per-page state already in some manner, but 
possibly he means it does under a given proposal and not in the current 
driver.

Even the #b remembering might end up being SELinux-specific if we also 
have to remember the original inputs used to compute the answer so that 
we can audit that information when access is denied later upon 
mprotect().  At the least we'd need it to save some opaque data and pass 
it to a callback into SELinux to perform that auditing.

