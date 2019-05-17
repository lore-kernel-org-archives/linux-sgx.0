Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BBEC04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 20:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74F252087E
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 20:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="gNvzIRdA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbfEQUsZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 16:48:25 -0400
Received: from upbd19pa11.eemsg.mail.mil ([214.24.27.86]:32140 "EHLO
        upbd19pa11.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728176AbfEQUsY (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 16:48:24 -0400
X-Greylist: delayed 786 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 16:48:20 EDT
X-EEMSG-check-017: 215180282|UPBD19PA11_EEMSG_MP11.csd.disa.mil
Received: from emsm-gh1-uea11.ncsc.mil ([214.29.60.3])
  by upbd19pa11.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 20:34:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558125291; x=1589661291;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=unLCV5RFwj4VvH7gKFtYYn3YZgY7tt8qH/eFyKMNp7U=;
  b=gNvzIRdAmgBO9AgWwis48Q/i+hRn5oR2yX1bvMKUDZLnskTH7hjiQACw
   +wX/W+qUqbL5UEUxfPm1CPoOSMRaBbGAZQsxx86NtjlRMcq/aTeWiEZKd
   NmTvYP2T84Czl0NsaD9u5qS8VAmVkWmRIUs8vDuWYr+RbfsNF/wG1bCGh
   rOWhInVnh1kFqtli31VTBH8e81h/pPMaCkp5gjc1CUHtq1PH57uc0aPCz
   MJaHDb8b7OSulnUy6YDii/2a22LP+ao2auP81Aw+Xsdwt0dhup2dY5lDT
   I4knDTWzajA7ddbQE7XmGTW05MT4twNeOmAdgrqTaQg2qBgaCjmX0hGxk
   Q==;
X-IronPort-AV: E=Sophos;i="5.60,481,1549929600"; 
   d="scan'208";a="27881599"
IronPort-PHdr: =?us-ascii?q?9a23=3AuZ8VdxZBqDBk2Vp5NS/OrUr/LSx+4OfEezUN45?=
 =?us-ascii?q?9isYplN5qZpcmzbR7h7PlgxGXEQZ/co6odzbaP6ua5ATZLuMvY+Fk5M7V0Hy?=
 =?us-ascii?q?cfjssXmwFySOWkMmbcaMDQUiohAc5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFR?=
 =?us-ascii?q?rwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/IAiroQnLq8UanZVuJqksxh?=
 =?us-ascii?q?bJv3dDZvhby35vKV+PhRj3+92+/IRk8yReuvIh89BPXKDndKkmTrJWESorPX?=
 =?us-ascii?q?kt6MLkqRfMQw2P5mABUmoNiRpHHxLF7BDhUZjvtCbxq/dw1zObPc3ySrA0RC?=
 =?us-ascii?q?ii4qJ2QxLmlCsLKzg0+3zMh8dukKxUvg6upx1nw47Vfo6VMuZ+frjAdt8eXG?=
 =?us-ascii?q?ZNQ9pdWzBEDo66YYQPFe4BNvtGoYf7qVUFsB+yCRCsCe7rzzNFgGL9068n3O?=
 =?us-ascii?q?Q7CQzIwRIuH9wOvnrXotv6OqgdXuKpw6fH1jjDc/Fb1C3h5ITUfB0so/eBVq?=
 =?us-ascii?q?9wf8rLzkkvEhvIgEiMqYP7JzOV1voCs26G5OR9UOKgkWonqwVvrTmv28whjZ?=
 =?us-ascii?q?LJiZ8Oyl3f6SV4wJo6Jd2/SEJhZ96kC4FfuzuVN4txXMMvWmdlszs5xL0eoZ?=
 =?us-ascii?q?O3YScHxZs9yxPfdvCLaZaE7x39WOqLPDt1gm9udqiliBao60egz/XxVsyz0F?=
 =?us-ascii?q?lXsCVIisLMtnUR1xzL7ciHV+d98l+h2TmR0wDT7flJIVwumqrBKp4h36Uwmo?=
 =?us-ascii?q?APsUXDAiD2mEL2gLWQdko44ein9/7rYrDnpp+YL4N0iwf+PboymsGnHOg1PQ?=
 =?us-ascii?q?cDU3Kb9OihzrHv40L0TKtQgvEriqXZtYrVJcUfpq63GQ9V1YMj5g6kDzi7y9?=
 =?us-ascii?q?QVhmUHLVJZdxKHiIjlIVfOIOviAvuljFSslylry+jcPrL9GpXNMmTDkLD5cL?=
 =?us-ascii?q?Z59k5c1A0zwMtF6JJREL4OPOj8WlfwtNzEFBA5Nxa4w+D5B9VhzokeQ36AAr?=
 =?us-ascii?q?eFMKPOtl+F/vkvLPeWa48Tojr9KeIp6OLujX8jmF8dZrWp3ZwPaHC4APtmOV?=
 =?us-ascii?q?6ZYX3qgtoaEGcKuBY+Q/LuiFGYTTFTYHOyVbom5j4nEIKmEZvDRoe1jbOdwi?=
 =?us-ascii?q?i0A4dWZmFaBVyWHnbodoOEW/gXZSKTJM9hjiILVby7R4A90hGusRfwy6B7Ie?=
 =?us-ascii?q?rM5i0YqZXj2cBx5+3OiREy8id5D8eD3GGXSWF7gGcISyUx3KBlrkx30k2D3r?=
 =?us-ascii?q?Rgg/xECdxT4OtEUgU/NZ7b1ex6EdHyWhnac9ePUlmmR8upATArQtI22d8ObF?=
 =?us-ascii?q?53G8++gRDbwyqqH7gVmqSQBJMq6KLc0Gb+Kt19y3nc0Kkhi1knQs1VOWK6ga?=
 =?us-ascii?q?5/8hDZB5TVnEWBi6aqaaMc0TbJ9GeCy2qOoU5ZXBdrUarbQX8fe1HWrdXl5k?=
 =?us-ascii?q?LCVrOuDLMnPRZcyc6GNKRHccPpjVpYS/f5ItjeYHy+m322BRmWwrOAdo3qe3?=
 =?us-ascii?q?8S3C/FEkgLjxgT/WqaNQg5Hiqhu3jRDCFqFV/0e0Pj6/R+qHeiQk8xyAGKaF?=
 =?us-ascii?q?dh2KSv9hEJgvycTusZ3qgYtyc5tzV0AFG90srIBNqYvQVhZqRcYcgm7Vdfz2?=
 =?us-ascii?q?3ZrQ19Poe4L6BmnFERbxp4s1np1xVtBYVKidIqo28yzApuNaKY10tMdyiG0p?=
 =?us-ascii?q?D0O73XLHTy/R+0Zq7I1VHRzsyW9r0M6PsmsVXjuh+mFk44/3VgydlV3GOW5o?=
 =?us-ascii?q?/WAwoKTZLxTkE3+gB4p77AeCk95IDU1Xp2PamvqDDC2NEpBOojyhm+eddSK6?=
 =?us-ascii?q?eEFA70E80HCMmiMu0qm161bh0aOOBe7rI7P8Sjd/Gewq6kIP5gnC66jWRA+I?=
 =?us-ascii?q?190FyD9zZ8Su7S2JYI2P+Y3gydVzfgllihtMH3mI9eaT4OGWq/zDDuBJRNaa?=
 =?us-ascii?q?1qYYYLFWCuLtWqydpkmZ7iRWRU9F65CFMAw8+mZxySYkf83Q1WyUQYv3inlT?=
 =?us-ascii?q?GkwDxzljEjtrCf0zDWw+T+aBoHPXZGRHVtjVfoLom5lNQaXEmubwg0iBul/0?=
 =?us-ascii?q?H6x65apKVwNWXcXFlHdTDsL25+SquwqqaCY8lX5ZMnqyVYTuu8bEuERb77oR?=
 =?us-ascii?q?sVzSfjH29fxD8nbT2lppL5nxligmKHMHlztGbZed13xRrH+NzcQuRR3iQcSy?=
 =?us-ascii?q?l8lDbXHUOxP92o/dWSipfCvfmyV2ymVp1Odynk0JmPtDe65W1tBx2zhfezms?=
 =?us-ascii?q?foEQIiyy/0y8FqVTnUrBb7eoTr06W6MeR6fkhnHVP86NR1Gpt4koQugJEdwm?=
 =?us-ascii?q?YahpqL8nodi2vzMstU2bj4bHUTQT4H2dnV4BLq2Ed7NHKG25r5VmmBwstmf9?=
 =?us-ascii?q?S7bWAb1yMm4sBJFqiU9rpEkjVxolaiqgLRe/d9lC8HyfQy8H4an/0JuA01wy?=
 =?us-ascii?q?WZA7ASG1RYPCP1mxST4NC/o75aZHigcbeuzkpyh9OhA6+YogFaRnn5fo0uHS?=
 =?us-ascii?q?hq7sVwKFjMymH86pn4eNnMatIergebkxTYj+hQM58xkvsKhSx6OWPypHElxe?=
 =?us-ascii?q?k7jQFo3Z6npoeHN2Rt/KW/AhJCMT31fcwT8Cn3jalChsaWw5yvHpJ5FzUNXJ?=
 =?us-ascii?q?voSuioEDcIuvThLAuOCiMzpWqbGbXFAQ+T8ltpr3XKE5qzLXGYOGEZzcl+RB?=
 =?us-ascii?q?maPEFfhhgUXDAmkZElDA+qwMjhcFp85j0K/F73tAZDyuJyOBnjSGvQuACoaj?=
 =?us-ascii?q?IsQpiFMBVW9h1C51vSMcGG9eJ8ATtY/pK/owCXMGOaZwNIDXwPWkGfBlDjOK?=
 =?us-ascii?q?Wu6sfE8+SCGuW+KP7Oa62UqeNCT/eI2Y6v0ox+8jaXNsWAJHljA+c42kVZQX?=
 =?us-ascii?q?B4Gt3VmjQVRCwSliLNddWWpBa6+i1rsM+/9O7nVx7o5YuKE7FSK8lg+wiqga?=
 =?us-ascii?q?efMO6dnCZ5JixZ1pMQ33DIz6IT3F4Piy50cTmtHq8NtS/LTKLMhKBXCwQXZD?=
 =?us-ascii?q?90NMtN96g8xBVCOdbHitPp0b51luQ6C1FYWlz7m8GoZdYGI3q9NFzZGkaEKL?=
 =?us-ascii?q?SGKiPNw8H0ZqOxUrlQjORStx2ttjeXCU7jPjKflzb3UxCjK/1DjCaePBZGoo?=
 =?us-ascii?q?Gybg5tCXT/TNLhchC7M8V4jTwszb0vmHPFL24cMT5nfkNMqL2Q8T1XgvFlF2?=
 =?us-ascii?q?Nd6XplKPGOmzyF4OnANpYWrfxrDzxvmOJC+3k10b9V7CBaS/xzmybetMNhrE?=
 =?us-ascii?q?++mOmV1jVnSAZOqipMhI+Tv0ViPr7Z9plbVHbG+xIN9mWQCwgQp9tkEt3vv7?=
 =?us-ascii?q?5fysTTlK7pLzdC6d3U99MGB8fIMMKHLGYhMR3xFT7XFgQFTCSnNWHCh0NHlv?=
 =?us-ascii?q?GS+WaYrpk8qpjwhpUOTqVXW0AyFvMfEk5lBsANII9rXjM4lr6WlNQI5Xugox?=
 =?us-ascii?q?nXWMVavI7IVumJDPXgLzaZirZEZx8Wzr/iMYsTMYj7iARebQxTmojbU27NQd?=
 =?us-ascii?q?dIozd6bQ589EFQ7H9WR2g60Ev9ax+k5DkVGOLizTAsjQ4rWvgg7Dfh5R8MI1?=
 =?us-ascii?q?POoCYh2B0qlc7NnSGacDm3Kry5G45RFXyn5AAKLprnTlMtPkWJlkt+OWKBHu?=
 =?us-ascii?q?8Agg=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2AlAABrGt9c/wHyM5BkHAEBAQQBAQcEAQGBUQcBAQsBg?=
 =?us-ascii?q?WYqgTsyKIQSiByKb1ABAQaBCC2JTo8HgXsJAQEBAQEBAQEBNAECAQGEQAKCN?=
 =?us-ascii?q?CM0CQ4BAwEBAQQBAQEBAwEBbCiCOikBgmcBBSMVQRALDgoCAiYCAlcGDQYCA?=
 =?us-ascii?q?QGCXz+BdxSrC4EvhUiDJYFGgQwoAYtQF3iBB4ERJ4JrPodOglgEjUSFfJRWC?=
 =?us-ascii?q?YINgg+QZgYblhijfziBVysIAhgIIQ+DJ4IaGI47IwMwgQYBAY9dAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by emsm-gh1-uea11.NCSC.MIL with ESMTP; 17 May 2019 20:34:48 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HKYhg5026883;
        Fri, 17 May 2019 16:34:43 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
References: <CALCETrX2ovRx3Rre+1_xC-q6CiybyLjQ-gmB4FZF_qCZ-Qd+4A@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E38CD@ORSMSX116.amr.corp.intel.com>
 <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <837CE33B-A636-4BF8-B46E-0A8A40C5A563@amacapital.net>
 <6d083885-1880-f33d-a54f-23518d56b714@tycho.nsa.gov>
 <20190517192823.GG15006@linux.intel.com>
 <c901ea99-5b43-a25d-03e8-55b4fce9c466@tycho.nsa.gov>
 <ED98AEC9-FFA3-4DA4-9B86-11D8AADC9151@amacapital.net>
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <1d152f34-e6ca-edf4-65e7-fa758187332e@tycho.nsa.gov>
Date:   Fri, 17 May 2019 16:34:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ED98AEC9-FFA3-4DA4-9B86-11D8AADC9151@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 4:14 PM, Andy Lutomirski wrote:
> 
>> On May 17, 2019, at 1:09 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>>
>>> On 5/17/19 3:28 PM, Sean Christopherson wrote:
>>>> On Fri, May 17, 2019 at 02:05:39PM -0400, Stephen Smalley wrote:
>>>>> On 5/17/19 1:12 PM, Andy Lutomirski wrote:
>>>>>
>>>>> How can that work?  Unless the API changes fairly radically, users
>>>>> fundamentally need to both write and execute the enclave.  Some of it will
>>>>> be written only from already executable pages, and some privilege should be
>>>>> needed to execute any enclave page that was not loaded like this.
>>>>
>>>> I'm not sure what the API is. Let's say they do something like this:
>>>>
>>>> fd = open("/dev/sgx/enclave", O_RDONLY);
>>>> addr = mmap(NULL, size, PROT_READ | PROT_EXEC, MAP_SHARED, fd, 0);
>>>> stuff addr into ioctl args
>>>> ioctl(fd, ENCLAVE_CREATE, &ioctlargs);
>>>> ioctl(fd, ENCLAVE_ADD_PAGE, &ioctlargs);
>>>> ioctl(fd, ENCLAVE_INIT, &ioctlargs);
>>> That's rougly the flow, except that that all enclaves need to have RW and
>>> X EPC pages.
>>>> The important points are that they do not open /dev/sgx/enclave with write
>>>> access (otherwise they will trigger FILE__WRITE at open time, and later
>>>> encounter FILE__EXECUTE as well during mmap, thereby requiring both to be
>>>> allowed to /dev/sgx/enclave), and that they do not request PROT_WRITE to the
>>>> resulting mapping (otherwise they will trigger FILE__WRITE at mmap time).
>>>> Then only FILE__READ and FILE__EXECUTE are required to /dev/sgx/enclave in
>>>> policy.
>>>>
>>>> If they switch to an anon inode, then any mmap PROT_EXEC of the opened file
>>>> will trigger an EXECMEM check, at least as currently implemented, as we have
>>>> no useful backing inode information.
>>> Yep, and that's by design in the overall proposal.  The trick is that
>>> ENCLAVE_ADD takes a source VMA and copies the contents *and* the
>>> permissions from the source VMA.  The source VMA points at regular memory
>>> that was mapped and populated using existing mechanisms for loading DSOs.
>>> E.g. at a high level:
>>> source_fd = open("/home/sean/path/to/my/enclave", O_RDONLY);
>>> for_each_chunk {
>>>          <hand waving - mmap()/mprotect() the enclave file into regular memory>
>>> }
>>> enclave_fd = open("/dev/sgx/enclave", O_RDWR); /* allocs anon inode */
>>> enclave_addr = mmap(NULL, size, PROT_READ, MAP_SHARED, enclave_fd, 0);
>>> ioctl(enclave_fd, ENCLAVE_CREATE, {enclave_addr});
>>> for_each_chunk {
>>>          struct sgx_enclave_add ioctlargs = {
>>>                  .offset = chunk.offset,
>>>                  .source = chunk.addr,
>>>                  .size   = chunk.size,
>>>                  .type   = chunk.type, /* SGX specific metadata */
>>>          }
>>>          ioctl(fd, ENCLAVE_ADD, &ioctlargs); /* modifies enclave's VMAs */
>>> }
>>> ioctl(fd, ENCLAVE_INIT, ...);
>>> Userspace never explicitly requests PROT_EXEC on enclave_fd, but SGX also
>>> ensures userspace isn't bypassing LSM policies by virtue of copying the
>>> permissions for EPC VMAs from regular VMAs that have already gone through
>>> LSM checks.
>>
>> Is O_RDWR required for /dev/sgx/enclave or would O_RDONLY suffice?  Do you do anything other than ioctl() calls on it?
>>
>> What's the advantage of allocating an anon inode in the above?  At present anon inodes are exempted from inode-based checking, thereby losing the ability to perform SELinux ioctl whitelisting, unlike the file-backed /dev/sgx/enclave inode.
>>
>> How would SELinux (or other security modules) restrict the authorized enclaves that can be loaded via this interface?  Would the sgx driver invoke a new LSM hook with the regular/source VMAs as parameters and allow the security module to reject the ENCLAVE_ADD operation?  That could be just based on the vm_file (e.g. whitelist what enclave files are permitted in general) or it could be based on both the process and the vm_file (e.g. only allow specific enclaves to be loaded into specific processes).
> 
> This is the idea behind the .sigstruct file. The driver could call a new hook to approve or reject the .sigstruct. The sigstruct contains a hash of the whole enclave and a signature by the author.

Ok, so same idea but moved to ENCLAVE_INIT and passing the vma or file 
for the sigstruct instead of the enclave.
