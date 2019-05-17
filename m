Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC28CC04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 20:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 928032166E
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 20:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho.nsa.gov header.i=@tycho.nsa.gov header.b="ouqpK5M5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfEQUJg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 16:09:36 -0400
Received: from ucol19pa10.eemsg.mail.mil ([214.24.24.83]:28555 "EHLO
        UCOL19PA10.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfEQUJf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 16:09:35 -0400
X-EEMSG-check-017: 677483922|UCOL19PA10_EEMSG_MP8.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.60,481,1549929600"; 
   d="scan'208";a="677483922"
Received: from emsm-gh1-uea10.ncsc.mil ([214.29.60.2])
  by UCOL19PA10.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA256; 17 May 2019 20:09:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tycho.nsa.gov; i=@tycho.nsa.gov; q=dns/txt;
  s=tycho.nsa.gov; t=1558123768; x=1589659768;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=3UmBo6wMB6w6oGvZCK1z7G3CZpTk54zpHXItYpR+poM=;
  b=ouqpK5M57aSQiPkMzScHN77w4TRn9ntbTiP6tBSixyZN5qjbzImBXEJ7
   badY8woU3/Fw7xf5lakpY2WjEt9S7b5eaj25YqbtnEtpZFjMJOfYLY/fI
   pf4Mgo5BZHiZu9oFwZdDoh/atozMrly2HJivX/S56YbNiBlTtFOOwARaw
   voS5dEQrmn5Js/FVCATQU5qkkmZuv6dhHgUf3gMd0ijEuFLdYnp6oyC6S
   goUrPWSvSdLCjmawwg19pVZpZQ0wjjVKd5LzGUOgdYV2CAd4eL378UPl3
   RTs1VJk+XtXybyKFGQB4msWzieBtcfumsoHtY722Ef3QZr8TTXwum37Fj
   g==;
X-IronPort-AV: E=Sophos;i="5.60,481,1549929600"; 
   d="scan'208";a="23851705"
IronPort-PHdr: =?us-ascii?q?9a23=3AONlBsx9kBL8p3/9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B91esTIJqq85mqBkHD//Il1AaPAdyCrasc0aGP7/6ocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmSexbalvIBmqswndudQajIRjJ60s1h?=
 =?us-ascii?q?bHv3xEdvhMy2h1P1yThRH85smx/J5n7Stdvu8q+tBDX6vnYak2VKRUAzs6PW?=
 =?us-ascii?q?874s3rrgTDQhCU5nQASGUWkwFHDBbD4RrnQ5r+qCr6tu562CmHIc37SK0/VD?=
 =?us-ascii?q?q+46t3ThLjlTwKPCAl/m7JlsNwjbpboBO/qBx5347Ue5yeOP5ncq/AYd8WWW?=
 =?us-ascii?q?9NU8BfWCxbBoO3cpUBAewPM+1Fq4XxvlsDoB+7CQSqGejhyCJHhmXu0KMnze?=
 =?us-ascii?q?ohHwHI0g8uEd0Av3vbrsn6OqgJXOCpzqTF1ynPY+9Y1Dr/7oXDbxAvoeuLXb?=
 =?us-ascii?q?J1acff1FUvGB3djlWQt4PlOS6e2PkIs2eB6+pgUfygim46oAx2uTig29wsh5?=
 =?us-ascii?q?LVhoMV1l/E9SJ5zJwzJd2jUkF3e9GkEJxOtyyDMYZ9X8AsQ3lwtSonxbALto?=
 =?us-ascii?q?S3cSgXxJg92RLSZOKLf5KV7h/lSe2fOy13hGh/d7K6nxuy9E+gxfDiWcSsy1?=
 =?us-ascii?q?ZKqzZFksHLtnAQyxzf8siHReV5/kemwTuPyxrc6vtFIUApjqrXMYIhw74smZ?=
 =?us-ascii?q?oTtkTPBCn2l1ntjKCKbEkk/+mo6+D/brXnoJ+TKZN0hxnjPqkhlcGzG+Q1Ph?=
 =?us-ascii?q?UUU2SF9umwyqfv8VDhTLVPlPI2k63ZsJ7AJcQco660GxRV3Zs46xukEzen0M?=
 =?us-ascii?q?gXnXkALF5ffhKHlJLmN0vBIPD/E/ezm06snytzx/DaIr3hBY3ALmPdn7j7e7?=
 =?us-ascii?q?Zx8UxcxBAvwtBf/ZJUC6oBIO70Wk/ptNzXEAU5Mxezw+bhE9h914UeWX6RDa?=
 =?us-ascii?q?+dKq/drViI5uc3KemWeIAVoCr9K+Qi5/P2iX85hEMdfa6y0JQNbXC3BOhpLF?=
 =?us-ascii?q?+BYXrtntcOC2MKshA4TOP0lF2ISSRTaGqqX6Ig+jE7D5qrApvdSY+wmryB3T?=
 =?us-ascii?q?u0EodZZ2BHDFCMHmzld4SCW/cQdi2SJtVtnSADVbikU4Uhzw2htBfmy7p7Ke?=
 =?us-ascii?q?rZ4ikYtY//1Nhy/ODTlg899SZyD8uD12GBVWZ0nnkHRzUuxqBwvVR9ykuf0a?=
 =?us-ascii?q?h/m/FYF9lT5/RTUgcgNJ7c1Pd3C9boVQLEYNiJSUyqQtK8ATE+Vtgx2cMBY1?=
 =?us-ascii?q?5hG9W+iRDOxzGqDKEPl7yEGpM56aLc0GL1J8Z5y3fG0rMtgEUhQstKLWemnL?=
 =?us-ascii?q?Jw9xDPB47VlEWUj6KqdaUa3C7Q+2aP1HGOs19EXw5tS6XFXGwfZ0vPodT84U?=
 =?us-ascii?q?PNUqKuCbA5PQZa186CJbVFasfzgVVFWvjjItLebHy1m2uqAhaI3LyMZpLwe2?=
 =?us-ascii?q?oBxCXdFFQEkwcL8HaeLwc+GyOhrnnGDDN0CFLvZ1rg8ex5qHO8VE870RuGYF?=
 =?us-ascii?q?Fm17qw4hQVn+CTS+sP3rIYvycssyt7HE6n0NLMCtqAvBFsfL1GbtMn4VdHzn?=
 =?us-ascii?q?rZtwhnMZO8Ma9unFkecx54v0n2zRV4Fp1AkdQ2rHMt1AdyMryX0FdAdzOewJ?=
 =?us-ascii?q?DxNabaKnf9/B+xca7awFLe38iM+qcJ9vs4r0/vvAazFkot639nycVa02OA5p?=
 =?us-ascii?q?XWCwofSZDxXVwt9xh5pLHaZTMx55jO2n1vMqm0sznC1MwvBOY+zhagftFfML?=
 =?us-ascii?q?6LFQPoEs0aAdSuJ/Ium1Szch0EO+VS/rYuP8y6b/uGxLKrPOF4kTKkk2tH/I?=
 =?us-ascii?q?B90liL9ydnRO7I2IwFw+2C0QuBVjf9g02tvdzwmYBBfTsSBHawyTD4BI5NYa?=
 =?us-ascii?q?1/ZZsEBn2wI8Kp3Nl+h4TiW3hD9FG9AVMLw86peRyOb1Pj2Q1cz1gYoXuimS?=
 =?us-ascii?q?Gg1Tx7jykprraD3CzJ2+niaBUHOmpERWR5iVfsII60j80GXEiyaAgpkhql5E?=
 =?us-ascii?q?ngy6dGuqt1N3PTTltQfyjqM2FiVbO9trWYY8FR55MlqjtYUOK+YV+ETr79px?=
 =?us-ascii?q?oa3D/5E2RCwzA7cimguo/lkBxilGKdMHFzoWLFecF33xff+sbTRfpM0TodXy?=
 =?us-ascii?q?R4jTjXBl6hP9im5NmUmZDDsv24V228TJJTbSjrzYSGtCeh4m1qGxK/leipmt?=
 =?us-ascii?q?L7CQg6zTP7195yWCXMrRb8ZJTr1qujPeJkYEZoHln85NR+GoxljIswi48f2W?=
 =?us-ascii?q?IAipWW43UHi2HzPstf2a7ka3oNXzELycbP4Af5wE1jMm6Jx4XhW3SSwcZsZs?=
 =?us-ascii?q?K3YmAI1SIn6cBFFqOU4KZDnStvrVqytRjRbuRlnjcB1fsu72YXg+UIuAor0y?=
 =?us-ascii?q?WcDakeHVJXPS3jjBmI8d++o7tNZGq1cri/ylB+nda/A7GGuA1cX2z5epg6Fy?=
 =?us-ascii?q?9q8sp/KE7M0GH06oz8YtbQbsoTthiPnhfEjuhVLo8xl/UTiSppPmL9oHslxP?=
 =?us-ascii?q?Mhghxy3JG6u46HJ39q/KKjDR5SLif1aN8L+jHxkaZemd6b34avHpVmADULWY?=
 =?us-ascii?q?HnTfSzHTIIq/voKgaOHycgqnuBBbXfGgqf4l98r33TC5CrK22XJH4BwNVkXB?=
 =?us-ascii?q?mdIVBQjxwOUzU+mp45CwWqydf7cEhn+z8R5kT3qgdWxu10MBn/V3/VpB20ZT?=
 =?us-ascii?q?csVJifMB1W4xlZ50jLK8ye4fx8EztC8ZyhqwyNN2qbah9JDWEPRkyLGVTjMq?=
 =?us-ascii?q?Oy6tnH9uiSHvC+IOfWYbWStexeUO+FxYmv0oR8/zeALMaPMWN+D/w6w0ZCXG?=
 =?us-ascii?q?p2G8HYmzUVUCEXliTNb9KFqxe44CF4sse/8PHzUgL1+YSPE6dSMclo+x2uga?=
 =?us-ascii?q?eMLe+QhDpjJjZfzJ8MxWLIx6IZ3F4dkCxudj+tEageui7JVq7fhqhXDxsDYS?=
 =?us-ascii?q?NpKMRI97483hVKOcPDkNz10KN3juQ0C1ZFT1DhgcGpatIUI26hNFPIGkCLNL?=
 =?us-ascii?q?eBJTDQx8H3YKW8SaBfjelOth2wvyqbHFHnPjiZizbpUBWvO/lWjC6HJBxepJ?=
 =?us-ascii?q?29chF1BGjgVt3mawe3MMRpjTIswb00gGjHNW8aMThgbUxNqqec4j9fgvV6A2?=
 =?us-ascii?q?ZB9GZqLfGYmyaF6OnVMo0ZseNwDytuk+Ja4Wo1y71W4S1eWfN6hjPYrsRyrF?=
 =?us-ascii?q?G+jumP1j1nXQJMqjZMn4KLvV5vOafe9plbWXbE4AgN7WSICxQOudRlFsHvt7?=
 =?us-ascii?q?pXytjVm6L5MC1C/M7M/csAG8jUL9qKMHk7PhroAjLUDBYFQiStNWHQnEFdkf?=
 =?us-ascii?q?eS9mGLoZg+sJTjhJ0OSrpDXlwvCvwaElhlHMAFIJpvRDMkkKCUjMgU5Xq8sh?=
 =?us-ascii?q?bRX95Xvp/AVvKVDvXvLCiWgaNYaBsPxLOrZbgUY7b20koqQVlgnZ/WHFLQUM?=
 =?us-ascii?q?pWpSspOhQ5qUML8j51TncywF7icgOg+mQUE9a1mAI7jk11ZuF7pxn25FJiHU?=
 =?us-ascii?q?bHvCs9lgEKnNzhhT2AOGrqILyYQZBdCy2ysVM4dJz8XVAmPkWJgUV4OWKcFP?=
 =?us-ascii?q?pqhLx6eDUu0VKNtA=3D=3D?=
X-IPAS-Result: =?us-ascii?q?A2AMAACLFN9c/wHyM5BkGwEBAQEDAQEBBwMBAQGBUQYBA?=
 =?us-ascii?q?QELAYFmKoE7MoQ6iByKb1ABAQaBCC2JTo8HgXsJAQEBAQEBAQEBNAECAQGEQ?=
 =?us-ascii?q?AKCNCM0CQ4BAwEBAQQBAQEBAwEBbCiCOikBgmcBBSMVQRALGAICJgICVwYNC?=
 =?us-ascii?q?AEBgl8/gXcUqweBL4VIgyaBRoEMKAGLUBd4gQeBESeCaz6HToJYBI1EhXyUV?=
 =?us-ascii?q?gmCDYIPkGYGG5YYo384gVcrCAIYCCEPgyiQbCMDgTYBAY9dAQE?=
Received: from tarius.tycho.ncsc.mil ([144.51.242.1])
  by EMSM-GH1-UEA10.NCSC.MIL with ESMTP; 17 May 2019 20:09:27 +0000
Received: from moss-pluto.infosec.tycho.ncsc.mil (moss-pluto [192.168.25.131])
        by tarius.tycho.ncsc.mil (8.14.4/8.14.4) with ESMTP id x4HK9MJF018240;
        Fri, 17 May 2019 16:09:22 -0400
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
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
From:   Stephen Smalley <sds@tycho.nsa.gov>
Message-ID: <c901ea99-5b43-a25d-03e8-55b4fce9c466@tycho.nsa.gov>
Date:   Fri, 17 May 2019 16:09:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517192823.GG15006@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 5/17/19 3:28 PM, Sean Christopherson wrote:
> On Fri, May 17, 2019 at 02:05:39PM -0400, Stephen Smalley wrote:
>> On 5/17/19 1:12 PM, Andy Lutomirski wrote:
>>>
>>> How can that work?  Unless the API changes fairly radically, users
>>> fundamentally need to both write and execute the enclave.  Some of it will
>>> be written only from already executable pages, and some privilege should be
>>> needed to execute any enclave page that was not loaded like this.
>>
>> I'm not sure what the API is. Let's say they do something like this:
>>
>> fd = open("/dev/sgx/enclave", O_RDONLY);
>> addr = mmap(NULL, size, PROT_READ | PROT_EXEC, MAP_SHARED, fd, 0);
>> stuff addr into ioctl args
>> ioctl(fd, ENCLAVE_CREATE, &ioctlargs);
>> ioctl(fd, ENCLAVE_ADD_PAGE, &ioctlargs);
>> ioctl(fd, ENCLAVE_INIT, &ioctlargs);
> 
> That's rougly the flow, except that that all enclaves need to have RW and
> X EPC pages.
> 
>> The important points are that they do not open /dev/sgx/enclave with write
>> access (otherwise they will trigger FILE__WRITE at open time, and later
>> encounter FILE__EXECUTE as well during mmap, thereby requiring both to be
>> allowed to /dev/sgx/enclave), and that they do not request PROT_WRITE to the
>> resulting mapping (otherwise they will trigger FILE__WRITE at mmap time).
>> Then only FILE__READ and FILE__EXECUTE are required to /dev/sgx/enclave in
>> policy.
>>
>> If they switch to an anon inode, then any mmap PROT_EXEC of the opened file
>> will trigger an EXECMEM check, at least as currently implemented, as we have
>> no useful backing inode information.
> 
> Yep, and that's by design in the overall proposal.  The trick is that
> ENCLAVE_ADD takes a source VMA and copies the contents *and* the
> permissions from the source VMA.  The source VMA points at regular memory
> that was mapped and populated using existing mechanisms for loading DSOs.
> 
> E.g. at a high level:
> 
> source_fd = open("/home/sean/path/to/my/enclave", O_RDONLY);
> for_each_chunk {
>          <hand waving - mmap()/mprotect() the enclave file into regular memory>
> }
> 
> enclave_fd = open("/dev/sgx/enclave", O_RDWR); /* allocs anon inode */
> enclave_addr = mmap(NULL, size, PROT_READ, MAP_SHARED, enclave_fd, 0);
> 
> ioctl(enclave_fd, ENCLAVE_CREATE, {enclave_addr});
> for_each_chunk {
>          struct sgx_enclave_add ioctlargs = {
>                  .offset = chunk.offset,
>                  .source = chunk.addr,
>                  .size   = chunk.size,
>                  .type   = chunk.type, /* SGX specific metadata */
>          }
>          ioctl(fd, ENCLAVE_ADD, &ioctlargs); /* modifies enclave's VMAs */
> }
> ioctl(fd, ENCLAVE_INIT, ...);
> 
> 
> Userspace never explicitly requests PROT_EXEC on enclave_fd, but SGX also
> ensures userspace isn't bypassing LSM policies by virtue of copying the
> permissions for EPC VMAs from regular VMAs that have already gone through
> LSM checks.

Is O_RDWR required for /dev/sgx/enclave or would O_RDONLY suffice?  Do 
you do anything other than ioctl() calls on it?

What's the advantage of allocating an anon inode in the above?  At 
present anon inodes are exempted from inode-based checking, thereby 
losing the ability to perform SELinux ioctl whitelisting, unlike the 
file-backed /dev/sgx/enclave inode.

How would SELinux (or other security modules) restrict the authorized 
enclaves that can be loaded via this interface?  Would the sgx driver 
invoke a new LSM hook with the regular/source VMAs as parameters and 
allow the security module to reject the ENCLAVE_ADD operation?  That 
could be just based on the vm_file (e.g. whitelist what enclave files 
are permitted in general) or it could be based on both the process and 
the vm_file (e.g. only allow specific enclaves to be loaded into 
specific processes).
